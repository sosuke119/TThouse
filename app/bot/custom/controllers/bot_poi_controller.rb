class BotPoiController
  attr_accessor :reply, :slot_hashes

  def initialize( bot_message ) 
    puts 'Enter BotPoiController'
    @bot_message = bot_message
    @slot_hashes = bot_message.slot_hashes
    
    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    case @bot_message.route
    when 'search_poi'
      
      @client   = GooglePlaces::Client.new(ENV['GOOGLE_MAP_KEY'])

      place_type_trans = {
        '餐廳'    => 'restaurant',
        '便利商店' => 'convenience_store',
        '停車場'  => 'parking'
      }


      @poi_type = place_type_trans[@slot_hashes['地點類別']]

      
      if @slot_hashes["目前座標"].blank?
        query_condition = "#{@slot_hashes['地址縣市']} #{@slot_hashes['地址區域']} #{@slot_hashes['地址路段']} #{@slot_hashes['地點類別']}"
        
        @rough_results  = @client.spots_by_query(
          query_condition,
          # types: [@poi_type],
          language: 'zh-TW')
      else
        lat  = @slot_hashes['目前座標'][0]
        long = @slot_hashes['目前座標'][1]

        @rough_results  = @client.spots(
          lat, long,
          keyword:"#{@slot_hashes['地點類別']}",
          language: 'zh-TW')
      end

      @place_ids = @rough_results.first(10).map(&:place_id)
      @results   = @place_ids.map{ |p_id| @client.spot(p_id,language:'zh-TW') }

      
    end
  end

  def set_reply_tempalte
    case @bot_message.route
    when 'search_poi'

      @template = BotPoiView.new(bot_message: @bot_message, results:  @results).reply

    
    end
  end

  def set_reply

    @reply = @template
    
  end


end