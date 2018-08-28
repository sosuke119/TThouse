class BotMessage

  attr_accessor :text, 
    :user,
    :message_type,
    :attachments, 
    :seq, 
    :sent_at, 
    :mid,
    :payload,
    :payload_name, 
    :luis,
    :tthouse_api_nlp,
    :intention_name, 
    :intention, 
    :bot_attachments,
    :payload_param,
    :source_type,
    :trigger,
    :trigger_type,
    :session,
    :slot_hashes,
    :route,
    :coordinate_array,
    :bot_luis,
    :platform



  def initialize(user:nil,source:nil, source_type:nil, platform: nil)
    @source       = source
    @source_type  = source_type
    @platform     = platform 

    case @platform
    when 'facebook'
      init_facebook
    when 'line'
      init_line
    end

    @user           = user
    @session        = @user.current_session
    
  end

  def init_line
    @text            = @source.text
    @source_type     = @source.source_type
    @message_type    = @source.message_type
    @sent_at         = @source.sent_at
    @mid             = @source.mid
    @payload         = @source.payload
    @bot_attachments = @source.bot_attachments
    @coordinate_array = self.set_coordinate

    self.set_payload_attr(@payload)
  end

  def init_facebook
    case source_type 
    when 'message'
      @message      = @source
      @text         = @source.text || 'None'
      @attachments  = @source.attachments
      
      self.set_payload(@source)
      self.set_payload_attr(@payload)

      @bot_attachments  = self.set_bot_attachments
      @coordinate_array = self.set_coordinate
      
      @seq          = @source.seq
      @mid          = @source.id
    when 'postback'
      @postback     = @source
      @text         = @source.try(:title)   || ''
      
      self.set_payload(@source)
      self.set_payload_attr(@payload)


      @attachments     = nil
      @bot_attachments = nil
      @coordinate      = nil
    when 'standby_message', 'standby_echo', 'conversation_message'

      @text         = @source.text || 'None'
      
      @seq          = @source.seq
      @mid          = @source.id

    end
    @sent_at        = @source.sent_at
    self.set_message_type
  end



  def set_message_type
    # image, vedio 
    if @source_type == 'standby_echo' or @source_type == 'standby_message'
      @message_type = @source_type
    elsif @attachments.present?
      @message_type = @attachments[0]['type']
    elsif @payload_name.present? && @text.present?
      @message_type = 'quick_reply'
    elsif @text.present?
      @message_type = 'text'
    else
      @message_type = @source_type
    end
  end

  def set_bot_attachments
    return nil unless @attachments.present?
    
    bot_attachments = []
    @attachments.each do |attachment_hash|
      bot_attachments << BotAttachment.new(attachment_hash:attachment_hash,platform:'facebook')
    end

    puts "
Bot Attachments: #{bot_attachments}
    "

    bot_attachments
  end

  def set_coordinate

    return nil if @bot_attachments.blank?
    bot_attachment = @bot_attachments.select { |atta| atta.attachment_type == "location" }[0]
    return nil if bot_attachment.try(:lat).blank?
    [bot_attachment.lat, bot_attachment.long]
  end

  def set_payload(source)
    case @platform
    when 'facebook'
      @payload = source.try(:quick_reply) || source.try(:payload) || nil
    when 'line'

    end
  end

  def set_payload_attr(payload)
    
    return unless payload.present?
    
    if  payload.include?('{') && payload.include?('}') && ( payload.include?(':') or payload.include?('=>') )
      
      begin 
        payload = eval(payload)
      rescue
      end
    else
      
      begin 
        payload = eval("{ name: '#{payload}' }")
      rescue
      end
    end

    puts payload

    if payload.kind_of?(Hash)
      @payload_param = payload
      @payload_name  = payload[:name]
      
    else
      @payload_param = {}
      @payload_name  = "error"
    end

  end




end