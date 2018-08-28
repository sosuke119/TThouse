class BotMessagesController

  attr_accessor :controller, :reply, :intention, :bot_message, :bot_session_controller, :user

  def initialize(user:nil, source:nil,source_type:nil, platform:nil  )
    puts "Enter BotMessagesController, source_type: #{source_type}"
   
    @bot_message  = BotMessage.new(user:user, source:source, source_type:source_type,platform:platform)

    @user         = @bot_message.user
    @source_type  = source_type
    
    self.set_session
    self.save_message_log
  end

  def set_session
    @bot_session_controller = BotSessionController.new(@bot_message)
  end 

  def controller
    @bot_session_controller.controller
  end

  def reply
    @bot_session_controller.reply
  end

  def save_message_log

    if @source_type == 'message'
      hash = {
        user_id:        @bot_message.user.id,
        text:           @bot_message.text,
        message_type:   @bot_message.message_type,
        payload_name:   @bot_message.payload_name,
        payload_param:  @bot_message.payload_param,
        payload_id:     @bot_message.payload.try(:id),
        tthouse_api_nlp:@bot_message.tthouse_api_nlp.to_json,
        sent_at:        @bot_message.sent_at,
        seq:            @bot_message.seq,
        mid:            @bot_message.mid
      }

      if @bot_message.bot_luis.present?
        hash[:intention_name]  = @bot_message.intention_name
        hash[:intention_id]    = @bot_message.intention.try(:id)
        hash[:intention_score] = @bot_message.bot_luis.result.try(:top_scoring_intent).try(:score)
        hash[:luis]            = @bot_message.bot_luis.result.to_json
      end

    else
      hash = {
        user_id:        @bot_message.user.id,
        text:           @bot_message.text,
        message_type:   @bot_message.message_type,
        payload_name:   @bot_message.payload_name,
        payload_param:  @bot_message.payload_param,
        payload_id:     @bot_message.payload.try(:id),
        sent_at:        @bot_message.sent_at,
      }

    end

    message_log = @bot_session_controller.session.message_logs.new( hash )

    if message_log.save!
      rendered_string = ApplicationController.render(
        template: 'message_logs/show.json',
        assigns: { message_log: message_log }
      )
      ActionCable.server.broadcast("board", { commit: 'addMessageLog', payload: rendered_string })
    end

    
    if  @bot_message.bot_attachments.present?
      @bot_message.bot_attachments.each do |bot_attachment|
        bot_attachment.save( message_log.id )
      end
    end

    puts "MessageLog: #{JSON.pretty_generate(hash)}"

  end

end
