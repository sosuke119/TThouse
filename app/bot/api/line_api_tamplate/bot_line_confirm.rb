class BotLineConfirm
  
  def self.new( text:nil, actions:nil )

    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
          "type": "confirm",
          "text": text,
          "actions": actions
      }
    }
  end

end