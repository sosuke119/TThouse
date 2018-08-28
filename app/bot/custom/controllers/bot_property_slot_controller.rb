class BotPropertySlotController

  attr_accessor :result, :query_string

  def initialize( slot_hashes)
    puts 'BotPropertySlotController'


    @slot_hashes = slot_hashes
    @result      = nil

    return unless @slot_hashes.present?
    
    self.set_conditions
    self.query
  end

  def set_conditions
    
    set_normal_condition
    set_range_condition
    set_special_condition
    set_coordinate_condition
    
    # to_a 避免nil
    @total_array  = @normal_array.to_a + @range_array.to_a + @special_array.to_a

  end

  def query

    unless @total_array.blank?
      @query_string = @total_array.map{ |h| "#{h[:name]} #{h[:sign]} '#{h[:value]}'" }.join(" AND ")
    end

     puts "@query_string #{@query_string}"
     
    if @coordinate.kind_of?(String) && @coordinate.include?("[")
      # 防呆，考慮刪掉
      @coordinate = JSON(@coordinate) 
    end
    
    if @coordinate.present? && @query_string.present?
      @result  = Property.within(2, :origin => @coordinate ).where(@query_string)
    elsif @coordinate.present?
      @result  = Property.within(2, :origin => @coordinate )
    else
      @result  = Property.where(@query_string)
    end

  end


private

  def set_normal_condition
    
    @normal = {
      "state"         => @slot_hashes["地址國家"],
      "city"          => @slot_hashes["地址縣市"],
      "area"          => @slot_hashes["地址區域"],
      "road"          => @slot_hashes["地址路段"],
      "title"         => @slot_hashes["地點名稱"],
      "address"       => @slot_hashes["地址"],
      "status"        => @slot_hashes["地點類別_建案型態"],
      "property_type" => @slot_hashes["地點類別_建案規劃"],
      "company"       => @slot_hashes["地點類別_建商名稱"],
    }.compact

    return if @normal.blank?

    @normal_array = to_array_of_hashes( @normal,'normal' )
  end

  def set_coordinate_condition
    return if @slot_hashes["目前座標"].blank?
    @coordinate  = @slot_hashes["目前座標"]
  end

  def set_range_condition


    @range = { 
      size_min: @slot_hashes["坪數"],
    }.compact

    price = @slot_hashes["金額"]
    unless price.blank?
      price_number = ( ChineseNumber.trans(price).to_i / 10000).to_s
      if @slot_hashes["價格"]  == '每坪價格'
        @range[:sec_price] = price_number
      else
        @range[:price]     = price_number
      end
    end


    @range = @range.compact


    return if @range.blank?

    @range_array  = to_array_of_hashes( @range, 'range'  )
  end

  def set_special_condition

    @special_array = []

    puts "@slot_hashes #{ @slot_hashes}"

    room = @slot_hashes["地點類別_建案格局"]
    if !room.blank? && room.include?('房')
      room_string = room      
      room_number = ChineseNumber.trans(room).to_i 

      if  @slot_hashes["範圍參考"].present? && room_number > 0
        @special_array += process_range_hashes(:room_min, room_number)
      else
        @special_array << { name: :room, value:"%#{room_string}%" , sign:'LIKE' }
      end
    end

    feature = @slot_hashes["地點類別_建案特色"]
    unless feature.blank?
      if feature == '含車位'
        @special_array << {name: :garage, value: 0 , sign:'>' } 
      end
    end
  end

  def to_array_of_hashes(cond_hash, type)
    case type
    when 'normal'
      cond_hash.map{ |key, value| {name: key, value: "%#{value}%", sign:'LIKE' } }
    when 'range'
      result = []
      cond_hash.each do |key, value| 
        result += process_range_hashes(key,value)
      end
      result
    end
  end

  def process_range_hashes(key, value)
    
    sign = nil
    case @slot_hashes["範圍參考"]
      when '以上' then sign = '>='
      when '以下' then sign = '<='
    end

    return [] if key.blank? or value.blank?

    if sign.present?
      [{name: key, value: value, sign:sign }]
    else
      # [
      #  {name: key, value: value*0.9, sign:'>=' },
      #  {name: key, value: value*1.1, sign:'<=' }
      # ]
      [
        {name: key, value: value, sign:'=' }
      ]
    end
  end

end