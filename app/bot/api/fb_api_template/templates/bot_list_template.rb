class BotListTemplate

  def self.new( list_items: nil, bottom_button: nil, top_element_style:'compact' )
    return 'list_items not array ' unless list_items.kind_of?(Array)

    if bottom_button.present?
      { 
        attachment: { 
          type: 'template', 
          payload: { 
            template_type: 'list',
            top_element_style: top_element_style,
            elements: list_items,
            buttons: [
              bottom_button
            ]
          }
        }
      }
    else
      { 
        attachment: { 
          type: 'template', 
          payload: { 
            template_type: 'list',
            top_element_style: top_element_style,
            elements: list_items,
          }
        }
      }
    end
  end

end

# "message": {
#   "attachment": {
#     "type": "template",
#     "payload": {
#       "template_type": "list",
#       "top_element_style": "compact",
#       "elements": [
#         {
#           "title": "Classic T-Shirt Collection",
#           "subtitle": "See all our colors",
#           "image_url": "https://peterssendreceiveapp.ngrok.io/img/collection.png",          
#           "buttons": [
#             {
#               "title": "View",
#               "type": "web_url",
#               "url": "https://peterssendreceiveapp.ngrok.io/collection",
#               "messenger_extensions": true,
#               "webview_height_ratio": "tall",
#               "fallback_url": "https://peterssendreceiveapp.ngrok.io/"            
#             }
#           ]
#         }
#       ],
#        "buttons": [
#         {
#           "title": "View More",
#           "type": "postback",
#           "payload": "payload"            
#         }
#       ]  
#     }
#   }
# }