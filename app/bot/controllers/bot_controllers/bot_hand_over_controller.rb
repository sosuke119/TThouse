class BotHandOverController
  attr_accessor :reply

  def initialize( bot_message ) 
    puts 'Enter BotHandOverController'
    
    @bot_message = bot_message
    @user        = @bot_message.user

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    case @bot_message.route
    when 'handover_confirm'
      last_session = @user.current_session
      if last_session.present? && !last_session.expired_at.present?
        last_session.update(
          state: 'finished_by_handed_over', 
          finished_at: Time.zone.now 
        )
      end
      new_session = @user.sessions.create(
        state: 'handed_over')
      # @bot_message.session.update( state: 'handed_over' )
      self.notify_admins
      # @bot_message.session.update( finished_at: Time.zone.now )
    when 'handover_done'
      user_id = @bot_message.payload_param.dig(:user_id)
      return unless user_id.present?
      
      session = User.find(user_id).sessions.where(state: 'handed_over').last
      return if session.expired_at.present?
      
      session.update(state: 'handed_over_finished' , finished_at: Time.zone.now )

    end
  end

  def set_reply_tempalte
    case @bot_message.route
    when 'handover_confirm'
      @template = BotHandOverView.handover_starting_message
    when 'handover_done'
      @template = [{text:'感謝您的協助。'}]
    end
  end

  def set_reply

    @reply = @template
    
  end

  def notify_admins
    message = BotHandOverView.notify_admin(@bot_message)

    User.admins.each do |admin|
      delivery = BotDeliver.new(user:admin, message:message )
      delivery.send
    end
  end

end