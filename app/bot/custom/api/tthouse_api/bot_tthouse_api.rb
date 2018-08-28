class BotTthouseApi

  attr_accessor :result_properties

  def initialize
    
  end


  def nlp(text)
    @text  = text
    @uri   = URI('https://cloud-app.azure-api.net/NB/predictQ.php')
    @param = URI.encode_www_form({ 'q' => @text })

    self.query

    ( @result.present? && @result.kind_of?(Hash) ) ? @result : nil

  end

  def recommend_properties(lat:nil, lon:nil, km:nil)

    @uri   = URI('https://cloud-app.azure-api.net/NB/newBuildQuery2.php')
    @param = URI.encode_www_form({
      'function' => 'Query',
      'page'     => '1',
      'lat'      => @lat.to_s,
      'lon'      => @lon.to_s,
      'km'       => '2'
    })

    self.query

    if @result.present? && @result.kind_of?(Hash) && @result[:Build].kind_of?(Array)
      result_to_properties
    else
      []
    end
    
  end

  def search_properties(params)

    params          ||= Hash.new

    # 配合對方欄位名稱
    params.delete(:status)
    params[:bkind]    = params.delete(:property_type)

    # 配合對方資料沒有「臺」
    params[:city] = params[:city].gsub('臺','台') if params[:city].present? 
    
    @uri              = URI('https://cloud-app.azure-api.net/NB/newBuildQuery2.php')
    
    params[:function] = 'Query'
    params[:page]     = 1
    params[:km]       = 2
    
    @param  = URI.encode_www_form(params)
    
    self.query

    return self.result_to_properties

  end

  def result_to_properties
    result = []
    if @result.present? && @result.kind_of?(Hash) && @result[:Build].kind_of?(Array)
      @result[:Build].each do |b|
        hash = {
          title:          b[:btitle],
          city:           b[:bcity],
          area:           b[:barea],
          road:           b[:baddress_s],
          property_type:  b[:bkind2],
          status:         b[:bkind1],
          sec_price:      b[:bprice],
          company:        b[:bbuilder],
          address:        b[:full_address],
          address_detail: b[:baddress],
          floor_status:   b[:bfloor],
          lat:            b[:lat],
          long:           b[:lng],
          price:          (b[:bpr_min].to_i)*10000,
          price_min:      (b[:bpr_min].to_i)*10000,
          price_max:      (b[:bpr_max].to_i)*10000,
          sec_min:        b[:bp_min],
          sec_max:        b[:bp_max],
          available:      (b[:bstatus] == '銷售中'),
          sales_status:   b[:bstatus],
          room:           b[:room],
          room_min:       b[:room_min],
          room_max:       b[:room_max],
          price_range:    b[:priceRange],
          public_rate:    b[:bpublicRate],

        }
        result << Property.new(hash)
        pending_property = PendingProperty.where(title:b[:btitle]).first
        
        # 更新或新建
        if pending_property.present?
          pending_property.assign_attributes(hash)
          pending_property.save if pending_property.changed?
        else
          PendingProperty.create(hash)
        end
      end

      puts "tthouse_api: #{result.count}"
      return result
    else
      puts "tthouse_api: 0"
      return []
    end
  end

  def query
    if @param.length > 0
      if @uri.query && @uri.query.length > 0
        @uri.query += '&' + @param
      else
        @uri.query = @param
      end
    end


    request = Net::HTTP::Get.new(@uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = 'c835e46e10d241379c78c8ca1e69713f'
    # Request body
    request.body = ""
    response = Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do |http|
      http.request(request)
    end

    @result = response.body.gsub("null","nil")

    if @result.kind_of?(String)
      begin 
        @result = eval(@result)
      rescue
        @result = nil
      end
    else
      @result = nil
    end

  end

end