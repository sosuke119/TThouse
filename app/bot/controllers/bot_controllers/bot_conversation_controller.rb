class BotConversationController 

  attr_accessor :reply

  def initialize( bot_message ) 
    puts 'Enter BotConversationController'
    @bot_message = bot_message

    self.set_reply
  end

  def set_reply

    trigger  = @bot_message.intention || @bot_message.payload 

    db_reply = trigger.try(:replies).try(:first)

    case @bot_message.platform
    when 'facebook'
      if db_reply.present?
        @reply  = [{ text: db_reply.text }]
      else
        @reply  = BotHandOverView.handover_confirm_type_three(trigger.try(:name),@bot_message.platform)
      end
    else
      if db_reply.present?
        @reply  = [{ type:'text', text: db_reply.text }]
      else
        @reply  = BotHandOverView.handover_confirm_type_three(trigger.try(:name),@bot_message.platform)
      end
    end

    
  end




end