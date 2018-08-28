class BotWelcomeController

  attr_accessor :reply

  def initialize( bot_postback ) 
    puts 'Enter BotWelcomeController'
    @bot_postback = bot_postback

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action

  end

  def set_reply_tempalte
    @template = [
      { text: '您好，我們是推推房，有什麼我們可以為您服務的嗎？' },
      { text: '您可以查詢特定地點或條件的房地產資訊，或者是依照你的所在位置查詢附近的房產資訊，我們馬上為您服務！' }
    ]
  end

  def set_reply

    @reply = @template
    
  end

    
end