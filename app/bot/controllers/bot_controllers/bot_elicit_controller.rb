class BotElicitController

  attr_accessor :reply

  def initialize( bot_message ) 
    puts 'Enter BotElicitController'
    @bot_message = bot_message

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    @session      = @bot_message.session
    @session_slot = @session.session_slots.required_but_empty.first
    @slot         = @session_slot.try(:slot)
  end

  def set_reply_tempalte
    
    bot_elict_view = BotElicitView.new(
      session_slot: @session_slot,
      triggers:     [@bot_message.trigger],
      session_state:@session.state,
      platform:     @bot_message.platform
      )

    @template = bot_elict_view.reply
    

  end

  def set_reply
    
    @reply = @template
    
  end

    
end