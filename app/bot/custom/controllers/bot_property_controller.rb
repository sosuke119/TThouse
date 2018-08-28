class BotPropertyController
  attr_accessor :reply, :slot_hashes

  def initialize( bot_message ) 
    puts 'Enter BotPropertyController'
    @bot_message = bot_message
    @properties  = []

    @exception   = []

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    case @bot_message.route
    when 'search_properties', 'recommend_properties'

      @slot_hashes    = @bot_message.slot_hashes
      slot_controller = BotPropertySlotController.new(@slot_hashes)
      @properties     = slot_controller.result
      @properties   = Property.order_by_distance( 
        @bot_message.user.coordinate_array, 
        @properties
      )
      @bot_campaign = BotCampaign.new( 
                      properties:  @properties, 
                      slots_value: @slot_hashes.values.compact
                    )

      if slot_hashes['目前座標'].present?
        lat  = slot_hashes['目前座標'][0]
        long = slot_hashes['目前座標'][1]

        user = @bot_message.user
        user.assign_attributes( lat:lat, long:long)
        user.save if user.changed?
      end

    when 'average_price'
      @slot_hashes    = @bot_message.slot_hashes
      slot_controller = BotPropertySlotController.new(@slot_hashes)
      @properties     = slot_controller.result

    when 'show_more_properties'
    
    end
  end

  def set_reply_tempalte
    case @bot_message.route
    when 'search_properties', 'recommend_properties'


      property_template = BotPropertyView.new(
        bot_message:@bot_message,
        bot_campaign:@bot_campaign,
        properties:nil
      ).reply


      @template = property_template


    when 'show_more_properties'

      @template = BotPropertyView.new(
        bot_message:@bot_message,
        bot_campaign:nil,
        properties:nil
      ).reply

    when 'average_price'

      @template = BotPropertyView.new(
        bot_message:@bot_message,
        bot_campaign:nil,
        properties:@properties
      ).reply

      @template  =  [{ text: "依照您的條件為您搜尋:" }] + @template


    end
  end

  def set_reply

    @reply = @template + BotPropertyTemplate.staging_debug(
      @bot_message.bot_luis.try(:result),
      @slot_hashes, 
      @bot_message.bot_luis.try(:entities_value)
    )
    
  end


end