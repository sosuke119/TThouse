class BotPropertyTemplate

  attr_accessor :template

  def initialize(template_name, platform, data_hash)
    @platform      = platform
    @template_name = template_name
    @data_hash     = data_hash

    set_variable
    set_template
  end

  def set_variable
    
    case @template_name

    when 'search_properties'
      @bot_campaign        = @data_hash[:bot_campaign]
      @banner_properties   = @bot_campaign.banner_properties
      @list_properties     = @bot_campaign.list_properties
      @more_properties     = @bot_campaign.properties_left
      @current_page_number = 1
    when 'show_more_properties'
      @property_ids        = @data_hash[:property_ids]
      @current_page_number = @data_hash[:current_page_number]
      property_ids         = @property_ids[ 4*(@current_page_number)-1..4*(@current_page_number)+2 ]
      @list_properties     = Property.where(id: show_property_ids)
    when 'show_average_price'
      @avr        = @data_hash[:avr]
      @price_word = @data_hash[:price_word]
    end

    
  end

  def set_template
    case @template_name

    when 'search_properties'
      
      @template = search_properties

    when 'show_more_properties'
      @template = show_more_properties

    when 'show_average_price'
      @template = show_average_price

    when 'hand_over'
      @template = BotHandOverView.handover_confirm(@platform)
    end
  end

  def show_average_price
    case @platform
    when 'facebook'
      if @avr.present?
        template = [{text: "#{@price_word}約為 #{@avr} 萬元 "}]
      else
        template = [{text: "抱歉，我們目前資料不足。"}]
      end 
    when 'line'
      if @avr.present?
        template = [
          { type: "text",
            text: "#{@price_word}約為 #{@avr} 萬元 "
          }
        ]
      else
        template = [
          { type: "text",
            text: "抱歉，我們目前資料不足。"
          }
        ]
      end 
    end
  end

  def show_more_properties

    case @platform
    when 'facebook'
      template = property_list_template
      template = [{text: "抱歉，沒有更多符合條件的建案"}] if template.blank?
      template
    when 'line'
      template = property_list_template
      template = [{ type: "text", text: "抱歉，沒有更多符合條件的建案"}] if template.blank?
      template
    end
  end

  def search_properties

    case @platform
    when 'facebook'
      template = []

      if @banner_properties.present? && @banner_properties.count >= 1
        template += property_carousel_template
      end

      if @list_properties.present? && @list_properties.count >= 2
        template += property_list_template
      end

      if @list_properties.present? && @list_properties.count == 1
        template += single_property_template
      end


      if template.blank?
        template  << {text: "抱歉，沒有符合條件的建案"} 
      else
        template.unshift({ text: "依照您的條件為您搜尋:" })
      end

      template
    when 'line'
      template = []

      if @banner_properties.present? && @banner_properties.count >= 1
        template += property_carousel_template
      end

      if @list_properties.present? && @list_properties.count >= 2
        template += property_list_template
      end

      if template.blank?
        template  << {text: "抱歉，沒有符合條件的建案"} 
      else
        template.unshift({type:'text', text: "依照您的條件為您搜尋:" })
      end

      template
    end
  end

  def single_property_template
    [
      {text: property_info(@list_properties[0], 'single_property') }
    ]
  end

  def property_carousel_template
    return [] unless @banner_properties.count >= 1
    case @platform
    when 'facebook'

      generics = []

      @banner_properties.each do |property|

        image_url    = property.images_path.present? ? property.images_path : ENV['TEST_IMG_URL']
        generic = BotGeneric.new(
          title:          "【#{property.status}】"+property.title+" | #{property.property_type}",
          image_url:      image_url, 
          subtitle:       property_info(property, 'new'),
          default_button: BotButton.new(button_type:'web_url', url: property.url ),
          buttons:        [BotButton.new(button_type:'web_url', title:'詳細資訊', url: property.url )]
        )
        generics << generic
      end
      
      [
        BotGenericTemplate.new(elements:generics)
      ]
    when 'line'
      carousels = []

      @banner_properties.each do |property|

        image_url    = property.images_path.present? ? property.images_path : ENV['TEST_IMG_URL']
        carousel = BotLineCarousel.new(
          title:     "【#{property.status}】"+property.title+" | #{property.property_type}",
          image_url: image_url, 
          text:      property_info(property, 'new'),
          buttons:   [BotLineButton.new(button_type:'web_url', text:'詳細資訊', url: property.url )]
        )
        carousels << carousel
      end
      
      [
        BotLineCarouselTemplate.new(elements:carousels)
      ]
    end
    
  end

  def property_list_template


    return [] unless @list_properties.count >= 2
    
    case @platform
    when 'facebook'

      list_items = []
      
      @list_properties.each do |property|
        
        property_url = property.url

        list_item_hash = {
          title:    property.title+" | #{property.property_type}",
          subtitle: property_info(property, 'new_list') , 
          # image_url: image_url
        }

        if property.url.present?
          list_item_hash[:button] = BotButton.new(button_type:'web_url', title:'詳細資訊', url: property.url )
        end
        
        list_item = BotListItem.new(list_item_hash)
        list_items << list_item

      end
      [
        BotListTemplate.new(
          list_items: list_items, 
          bottom_button: more_property_button, 
          top_element_style:'compact'
        )
      ]
    when 'line'

      list_items = []
      
      @list_properties.each do |property|
        
        property_url = property.url

        list_item_hash = {
          title:    property.title+" | #{property.property_type}",
          subtitle: property_info(property, 'new_list') , 
          # image_url: image_url
        }

        if property.url.present?
          list_item_hash[:button] = property.url
        end
        
        list_item = BotLineList.new(list_item_hash)
        list_items << list_item

      end
      
      list_items

    end
    
  end

  def more_property_button
    property_ids = @more_properties.pluck(:id).first(100)

    return nil if property_ids.size - @current_page_number * 4 < 2

    button_hash = { 
      title:'查看更多',
      payload: BotPayload.new({
        name: 'show_more_properties',
        page: @current_page_number,
        property_ids: property_ids
      })
    }

    BotButton.new(button_hash)
  end

  def property_info(property, template)
    if property.sec_price.present?
      price          = property.sec_price
      sec_price_info = "#{price} 萬/坪"
    end

    if property.price.present?
      price      = property.price
      price_info = "總價 #{price}萬"
    end

    if property.status
      property_status = "[#{property.status}]"
    end

    if property.property_type
      property_type   = property.property_type
    end

    case template
    when 'new'
      "#{property.area}#{property.address}\n#{price_info}\n#{sec_price_info}(約#{property.size_min}坪)\n"
    when 'new_list'
      "#{price_info}\n#{sec_price_info}(約#{property.size_min}坪)\n"
        when 'single_property'
      "【#{property.status}】#{property.title} | #{property.property_type}\n\n地址：#{property.address}\n\n#{price_info}\n\n#{sec_price_info}(約#{property.size_min}坪)\n"
    end
  end

  def self.staging_debug(luis, slot_hashes, entities_value)
    return_hash = []


    if luis.present? && luis.intents.present?
      result = luis.intents.first(3).map{|i| " #{i.intent}: #{i.score.round(3)} " }
      return_hash << {text: "Intents:\n"+JSON.pretty_generate(result) }
    end
    if slot_hashes.present?
      return_hash << {text: "Slots:\n"+JSON.pretty_generate(slot_hashes) }
    end
    if entities_value.present?
      return_hash << {text: "LUIS :\n"+JSON.pretty_generate(entities_value)}
    end

    return return_hash
  end

end