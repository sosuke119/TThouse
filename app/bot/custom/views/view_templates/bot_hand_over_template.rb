class BotHandOverTemplate
  
  def self.handover_confirm_message
    
    text = "讓我為您轉接其他客服人員?"

    quick_replies = [
      BotButton.new( title: "好的", payload: "handover_confirm" ),
      BotButton.new( title: "取消", payload: "cancel" )
    ]

    BotButtonTemplate.new( text: text , buttons: quick_replies )
  end

end