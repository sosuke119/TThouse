class BotChatroomController
  

  def initialize(user:nil, source:nil, source_type:nil)
    puts "Enter BotChatroomController"
    @user = user
    @source = source
    @session = @user.current_session
    
    case source_type
    when 'message'
      if @session && @session.in_conversation
        self.send_to_conversation
        @source_type  = 'conversation_message'
      else
        @source_type  = 'standby_message'
      end
    when 'echo'
      @source_type  = 'standby_echo'
    end

    BotHandOverLogController.new(
      user:@user,
      source:@source,
      source_type: @source_type )
  end

  def send_to_conversation
    @receiver = @session.receiver
    text      = @source.text

    if text.present?
      message = { text: "#{@user.first_name} #{@user.last_name}: "+text }
      bot_deliver = BotDeliver.new(user: @receiver, message:message)
      bot_deliver.send
    end
  end
  
end