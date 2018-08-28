class BotListItem

  def self.new( title: nil ,subtitle:nil, image_url:nil, button: nil )

    if button.present?
      {
        title: title,
        subtitle: subtitle,
        image_url: image_url,
        buttons: [ 
          button 
        ]
      }
    else
      {
        title: title,
        subtitle: subtitle,
        image_url: image_url,
      }
    end

  end

end

# {
#   "title": "Classic T-Shirt Collection",
#   "subtitle": "See all our colors",
#   "image_url": "https://peterssendreceiveapp.ngrok.io/img/collection.png",          
#   "buttons": [
#     {
#       "title": "View",
#       "type": "web_url",
#       "url": "https://peterssendreceiveapp.ngrok.io/collection",
#       "messenger_extensions": true,
#       "webview_height_ratio": "tall",
#       "fallback_url": "https://peterssendreceiveapp.ngrok.io/"            
#     }
#   ]
# }