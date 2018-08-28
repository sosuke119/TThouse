class BotMessageTriggerController
  attr_accessor :trigger,:trigger_type, :bot_luis, :tthouse_api_nlp, :confirm_intent_id

  def initialize( bot_message ) 
    @bot_message = bot_message

    self.initialize_trigger
    self.set_trigger
  end

  def initialize_trigger
    case @bot_message.message_type
    when 'quick_reply', 'postback'
      @payload_name = @bot_message.payload_name
    when 'image', 'file'
      @payload_name = @bot_message.message_type
    when 'location'
      @payload_name = 'send_location'
    else
      self.nlp
    end
  end

  def nlp
    return if @bot_message.text.blank?
    
    @bot_luis        = BotLuis.new(@bot_message.text)
    @intention_name  = @bot_luis.intention_name
    @tthouse_api_nlp = BotTthouseApi.new.nlp(@bot_message.text)

  end

  def set_trigger
    if @payload_name.present? &&  @payload_name == 'confirm_new_intent'
      @confirm_intent_id  = @bot_message.payload_param[:intent_id]
      @intention          = Intention.where(id: @confirm_intent_id).first
      @trigger_type       = 'Intention'

    elsif @payload_name.present?
      @payload      = Payload.where(name:@payload_name).first_or_create(name: @payload_name)
      @trigger_type = 'Payload'
    end

    if @intention_name.present?
      @intention     = Intention.where(name:@intention_name).first_or_create(name:@intention_name) 
      @trigger_type  = 'Intention'
    end

    @trigger = @payload || @intention

    if @trigger.present? && @trigger.name == "None"
      @trigger = nil
    end
  end

end