class BotSessionSlotController

  attr_accessor :session_slots_objects, :session_slot_updated

  def initialize(bot_message:nil,
    session:       nil,
    session_slot:  nil,
    session_slots: nil,
    processor:     nil 
  )

    @bot_message   = bot_message
    @session       = session
    @session_slot  = session_slot
    @session_slots = session_slots

    case processor
    when 'init'
      self.fill_init_values
    when 'update'
      self.set_update_value
      self.update_value

      self.special_filling
      self.special_update
    end
      
  end 


  def set_update_value

    @value   = nil
    @session_slots ||= @bot_message.session.session_slots
    
    self.fill_value_with_quick_reply
    
    if @value.blank?
      self.fill_value_with_entities
    end
    if @value.blank?
      self.fill_value_with_message_attachments  
    end
    if @value.blank?
      self.fill_unrecognized_value
    end

  end

  def special_update
    [@city,@area,@road].each do |session_slot|
      next unless session_slot.present?
      session_slot.save if session_slot.changed?
    end
  end

  def fill_value_with_quick_reply
    return unless @bot_message.payload_name == 'prompt_option'
    @value = @bot_message.text
  end

  def update_value
    if @value.present?
      @session_slot.update(value: @value)
      @session_slot_updated = true
    else
      @session_slot_updated = false
    end
  end


  def fill_init_values
    @session_slots.each do |session_slot|
      @value        = nil
      @session_slot = session_slot
      self.fill_init_value
      session_slot.value    = @value
      session_slot.position = @position
    end

    self.required_filter
    self.special_filling

    @session_slots_objects = @session_slots
  end

  def fill_init_value
    
    self.fill_value_with_entities
    return unless @value.blank?

    self.fill_value_with_message_attachments
    return unless @value.blank?
    
    self.fill_unrecognized_value
    return unless @session_slot.required? && @value.blank?
    
    self.fill_value_with_db

  end

  def fill_value_with_message_attachments
    case @session_slot.name
    when '新座標','目前座標'
      return unless @bot_message.coordinate_array.present?
      @value = @bot_message.coordinate_array.to_json 
    end
  end

  def fill_value_with_entities

    @entities_hash = @bot_message.bot_luis.try(:entities_hash)
    @entities_positions = @bot_message.bot_luis.try(:entities_positions)

    return unless @entities_hash.present?

    case @session_slot.name
    when '金額','坪數'
      value_array = @entities_hash[@session_slot.name]
      price = value_array[0] if value_array.present?
      return unless price.present?
      
      value  = ChineseNumber.trans(price.gsub(',','') )

      @value = value.to_i.to_s unless value.blank?
    else

      value_array = @entities_hash[@session_slot.name]
      
      return unless value_array.present?
      # 是否有多個可能的值
      if value_array.size == 1
        @value    = value_array[0]
        # @position = @entities_positions[@value]
      elsif value_array.size > 1
        filling_multiple_value
      end
    end 
   
  end

  def filling_multiple_value
    case @session_slot.name
    when '價格'
      value_array = @entities_hash[@session_slot.name]
      return unless value_array.present?
      
      @value       = value_array.select{ |value| value == '每坪價格' }[0]
      @value     ||= value_array.select{ |value| value == '實價登錄' }[0]
      @value     ||= value_array.select{ |value| value == '成交行情' }[0]
      @value     ||= value_array.select{ |value| value == '總價' }[0]
    else
      value_array = @entities_hash[@session_slot.name]
      if value_array.kind_of?(Array)
        @session_slot.prompt_options = value_array.to_json 
        @session_slot.required = true
      end
    end
  end 

  def special_filling
    
    @city = @session_slots.select{|ss| ss.name == '地址縣市'}.first

    return unless @city.present? && @city.required

    @area = @session_slots.select{|ss| ss.name == '地址區域'}.first
    @road = @session_slots.select{|ss| ss.name == '地址路段'}.first


    case [@city.value.present?,@area.value.present?,@road.value.present?]

    when [false,true ,true ],[false,false,true ],[false,true,false]
      
      if @area.value.present?
        city_ids = Area.where(name:@area.value).pluck(:city_id).uniq.compact
      elsif @road.value.present?
        area_ids = Road.where('name like ?',"%#{@road.value}%").pluck(:area_id).uniq.compact
        city_ids = Area.where(id:area_ids).pluck(:city_id).uniq.compact
      else
        city_ids = []
      end

      # 是否有多個可能縣市
      if city_ids.size == 1
        @city.value = City.find(city_ids.first).name
        # 有路名就不需要指定區域
        if @road.value.present?
          @area.is_hint  = false
          @area.required = false
        end
      elsif city_ids.size > 1
        city_names = City.where(id:city_ids).pluck(:name).uniq.compact
        # 區域能否決定縣市
        if @city.prompt_options.present?
          city_by_area = city_names && JSON(@city.prompt_options)
          @city.value = city_by_area if city_by_area.size == 1
        else
          @city.prompt_options = city_names.to_json
        end
      end
    end
    
  end

  def special_filling_update
    @session_slots.each do |ss|
      ss.save if ss.changed?
    end
  end

  def required_filter
    
    case @session.trigger.name
    when '查詢價格','查詢地點_房地產','查詢地點'
      address_array = [
        "地址縣市", 
        "地址路段", 
        "地址區域"
      ]

      near_by_array = [
        "地址參考"
      ]

      filled_slots_names = @session_slots.map{ |session_slot| 
        session_slot.name unless session_slot.value.blank? 
        }.compact
     
      if !self.session_slots_name_include_array(filled_slots_names, address_array) && self.session_slots_name_include_array(filled_slots_names, near_by_array)
        @session_slots.map{ |session_slot|
          if address_array.include?(session_slot.name) 
            session_slot.required = false
            session_slot.is_hint  = false
          end
        }
        @session_slots.map{ |session_slot| session_slot.required = true  if session_slot.name == '目前座標' }
      end
    end

  end

  def session_slots_name_include_array(filled_slots_names, array)
    
     filled_slots_names.each do |ss|
      return true if array.include?(ss)
    end
    false
  end

  def fill_value_with_db

    user      = @bot_message.user
    slot_name = @session_slot.name

    return unless ['目前座標', '地址國家'].include?(slot_name)

    case slot_name
    when '目前座標'

      coordinate_array = user.coordinate_array.to_json
      @value = coordinate_array unless coordinate_array.blank? or user.coordinate_expired
    when '地址國家'
      case user.locale
      when 'zh_TW'
        # return '台灣'
      end
    end
  end

  def fill_unrecognized_value
    case @session_slot.name
    when '地址路段'
      query_road_attr
    when '地點名稱'
      query_property_attr('title')
    when '地點類別_建商名稱'
      query_property_attr('company')
    end
  end


# slot 處理

  def query_road_attr

    text = @bot_message.text
    
    return unless text.present?
    return unless text.match(/[路街道]/).present?

    result   = nil
    
    road_array = Road.all.pluck(:name).uniq.compact.reject(&:empty?)
    puts road_array
    road_array.each do |road|
      
      if text.include?(road)
        result = road
        break 
      end
    end

    @value = result
  end

  def query_property_attr(attr_name)

    text = @bot_message.text
    
    return unless text.present?

    case attr_name
    when 'road'
      return unless text.match(/[路街道]/).present?
    end

    result   = nil
    attr_sym = attr_name.to_sym
    
    property_attr_array = Property.pluck(attr_sym).uniq.compact.reject(&:empty?)
    property_attr_array.each do |property_attr|
      
      if text.include?(property_attr)
        result = property_attr
        break 
      end
    end

    @value = result

  end
  

end