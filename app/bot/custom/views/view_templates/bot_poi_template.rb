class BotPoiTemplate

  attr_accessor :template

  def initialize(template_name, platform, data_hash)
    puts 'Enter BotPoiTemplate'
    @platform      = platform 
    @template_name = template_name
    @data_hash     = data_hash
    puts "@platform #{@platform}"
    puts "@template_name #{@template_name}"
    puts "@data_hash #{@data_hash}"
    puts "search_poi #{search_poi}"
    set_variable
    set_template
  end

  def set_variable
    
    case @template_name
    when 'search_poi'
      
    end

    
  end

  def set_template
    case @template_name
    when 'search_poi'
      
      @template = search_poi
    end
  end

  def search_poi
    case @platform
    when 'facebook'
      @results = @data_hash[:results]

      if @results.blank? or @results.count == 0
        return [ {text: '抱歉，沒有符合條件的地點'} ] 
      end
      
      generics = []

      @results.first(10).each do |result|
        
        image_url   = result.photos[0].fetch_url(300) if result.photos[0].present?

        image_url ||=  ENV['TEST_IMG_URL']
        if result.opening_hours.present?
          open_now = result.opening_hours["open_now"] ? '營業中' : '休息中'
        end

        generic = BotGeneric.new(
          title:          "#{result.name}",
          image_url:      image_url, 
          subtitle:       "評分：#{result.rating}\n地址：#{result.formatted_address}\n營業狀態：#{open_now}\n電話：#{result.formatted_phone_number}",
        )

        if result.url.present?
          # generic[:default_button] = BotButton.new(button_type:'web_url', url: result.url ),
          generic[:buttons]        = [BotButton.new(button_type:'web_url', title:'導航', url: result.url )]
        end
        if result.website.present?
          button = BotButton.new(button_type:'web_url', title:'官方網站', url: result.website )
          if generic[:buttons].present?
            generic[:buttons] << button 
          else
            generic[:buttons] = button
          end
        end
        generics << generic
      end

      
      return [
        BotGenericTemplate.new(elements:generics)
      ]
    when 'line'

    end
  end

end