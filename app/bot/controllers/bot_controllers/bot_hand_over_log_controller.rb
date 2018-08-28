class BotHandOverLogController

  def initialize(user:nil, source:nil,source_type:nil )
    puts "Enter BotHandOverController, source: #{source}, source_type: #{source_type}"

    @source_type  = source_type
    @bot_message  = BotMessage.new(user:user,source:source, source_type:source_type , platform:'facebook')

    self.save_message_log
  end

  def save_message_log

    case @source_type
    when 'conversation_message'
      @source = 'service_2'
    when 'standby_echo'
      @source = 'service_1'
    when 'standby_message'
      @source = 'user'
    end

    case @source_type
    when 'standby_message', 'standby_echo', 'conversation_message'
      
      hash = {
        user_id:      @bot_message.user.id,
        text:         @bot_message.text,
        message_type: @bot_message.message_type,
        sent_at:      @bot_message.sent_at,
        seq:          @bot_message.seq,
        mid:          @bot_message.mid,
        source:       @source
      }
    end

    message_log = @bot_message.session.message_logs.new( hash )
    
    if message_log.save!
      
      rendered_string = ApplicationController.render(
        template: 'message_logs/show.json',
        assigns: { message_log: message_log }
      )
      
      ActionCable.server.broadcast("board", { commit: 'addMessageLog', payload: rendered_string })
    end

  end

end
