class BotLineButton

  
  def self.new( url:nil, text:nil, button_type:'postback', payload:'postback_payload')

    case button_type
    when 'web_url'
      {  
        "type": "uri",
        "label": text,
        "uri": url
      }
    when 'postback'
      {  
        "type": "postback",
        "label": text,
        "data": payload,
      }
    end

  end

  def self.cancel_bubble
    {  
      "type": "postback",
      "label": '取消',
      "data": BotPayload.new('cancel'),
    }
  end
end