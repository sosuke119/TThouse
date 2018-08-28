class BotLineMessage

  attr_accessor :text, 
    :source_type,
    :message_type, 
    :sent_at, 
    :mid,
    :payload,
    :bot_attachments


  def initialize(event)

    @event        = event
    @source_type  = set_source_type
    @message_type = set_message_type

    self.set_sent_at
    
    
    case source_type
    when 'message'
      @source = @event.message
      @mid    = @source['id']
      @text   = @source['text']
    when 'postback'
      puts @event
      puts @event['postback']
      @source  = @event['postback']
      @payload = @source['data']
      @text    = ''
    end

    self.set_bot_attachments
    
    

  end

  def set_sent_at
    @sent_at  = Time.zone.now
  end

  def set_source_type
    
    case @event
    when Line::Bot::Event::Message
      'message'
    when Line::Bot::Event::Postback
      'postback'
      #postback.data
    end
  end

  def set_message_type
    case @source_type
    when 'postback'
      return 'postback'
    end

    case @event.type
    when Line::Bot::Event::MessageType::Text
      'text'
    when Line::Bot::Event::MessageType::Location
      'location'
    when Line::Bot::Event::MessageType::Image
      'image'
    when Line::Bot::Event::MessageType::Video
      'video'
    when Line::Bot::Event::MessageType::Audio
      'audio'
    end
  end

  def set_bot_attachments
    @bot_attachments = []
    case @message_type
    when 'location'
      @bot_attachments << BotAttachment.new(attachment_hash:@source, platform:'line')
    end
  end

end