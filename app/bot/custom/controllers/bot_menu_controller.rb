class BotMenuController
  attr_accessor :reply

  def initialize( bot_message ) 
    puts 'Enter BotMenuController'
    @bot_message = bot_message
    @user        = @bot_message.user

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    case @bot_message.route
    when 'services_list'
    when 'tt_media'
    end
  end

  def set_reply_tempalte
    case @bot_message.route
    when 'services_list'
      @template = BotMenuView.menu
    when 'tt_media'
      @template = BotMenuView.media
    when 'tt_home_page'
      @template = BotMenuView.home_page
    end
  end

  def set_reply

    @reply = @template
    
  end

end