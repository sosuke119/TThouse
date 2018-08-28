class BotPropertyView

  attr_accessor :reply

  def initialize(bot_message:nil,bot_campaign:nil,properties:nil)
    @bot_message  = bot_message
    @route        = bot_message.route
    @slot_hashes  = @bot_message.slot_hashes
    @bot_campaign = bot_campaign
    @properties   = properties
    @platform     = bot_message.platform || 'facebook'

    set_reply_template
    set_data_hash
    set_template_controller
    set_reply
  end

  def set_reply_template
    case @route
    when 'search_properties', 'recommend_properties'
      @template_name  = 'search_properties'

    when 'average_price'
      if @slot_hashes.blank?
        @template_name = 'hand_over' 
      end
        
      case @slot_hashes["價格"]
      when '每坪價格', '總價'
        @template_name = 'show_average_price'

      when '成交行情', '實價登錄'
        @template_name = 'hand_over'
      else
        @template_name = 'hand_over'
      end
    # when 'show_more_properties'
    else
      @template_name  = @route
    end
  end

  def set_data_hash

    @data_hash = {}

    case @template_name
    when 'search_properties'
      @data_hash[:bot_campaign]        = @bot_campaign
      @data_hash[:current_page_number] = 1
    
    when 'show_more_properties'
      @data_hash[:property_ids]        = @bot_message.payload_param.dig(:property_ids)
      @data_hash[:current_page_number] = @bot_message.payload_param.dig(:page)+1
    
    when 'show_average_price'

      @data_hash[:price_word]          = @slot_hashes["價格"]
      
      case @slot_hashes["價格"]
      when '總價'
        @data_hash[:avr] = BotProperty.avr_price_total(@properties)
      when 
        @data_hash[:avr] = BotProperty.avr_price_per_footage(@properties)
      end
    end


    

  end

  def set_template_controller
    @template_controller = BotPropertyTemplate.new(
      @template_name, 
      @platform,
      @data_hash
    )
    @template = @template_controller.template
  end


  def set_reply
    @reply = @template
  end


end
