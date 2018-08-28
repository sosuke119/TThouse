class BotHandOverView

  def self.handover_confirm(platform)
    case platform
    when 'facebook'
      [
        { text: "根據你的需要" },
        BotHandOverTemplate.handover_confirm_message
      ]
    when 'line'
      [
        { 
          type: 'text',
          text: "很抱歉，目前無法理解您的問題。" 
        },
      ]
    end
  end

  def self.handover_confirm_type_three(name, platform)
    [
      { text: "根據你的需要" },
      BotHandOverTemplate.handover_confirm_message
    ]
  end

  def self.handover_starting_message
    [
      # {text:'很抱歉，現在所有客服都在忙線中，我們會盡快與您聯繫！'}

      { text: "已為您轉介，請稍等，其他同事會立即接手！" }

    ]
  end

  def self.notify_admin(bot_message)

    buttons  = [
      BotButton.new( 
        title:"對話結束", 
        button_type:'postback', 
        payload: BotPayload.new( { name: 'handover_done', user_id: bot_message.user.id } )
      )
    ]
    
    elements = [
      BotGeneric.new( 
        title:'請至粉專收件夾協助回覆訊息',
        image_url:bot_message.user.profile_pic, 
        subtitle:"
        First Name：#{bot_message.user.first_name}
        Last Name：#{bot_message.user.last_name}",
        buttons:buttons
      )
    ]

    BotGenericTemplate.new( elements:elements )

  end

end