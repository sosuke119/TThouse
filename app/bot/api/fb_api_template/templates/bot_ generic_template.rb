class BotGenericTemplate
  

  def self.new( elements:nil )

 
    { 
      attachment: { 
        type: 'template', 
        payload: { 
          template_type: 'generic',
          elements: elements
        } 
      }
    }
  end

end

# "message":{
#   "attachment":{
#     "type":"template",
#     "payload":{
#       "template_type":"generic",
#       "elements":[
#          {
#           "title":"Welcome to Peter\'s Hats",
#           "image_url":"https://petersfancybrownhats.com/company_image.png",
#           "subtitle":"We\'ve got the right hat for everyone.",
#           "default_action": {
#             "type": "web_url",
#             "url": "https://peterssendreceiveapp.ngrok.io/view?item=103",
#             "messenger_extensions": true,
#             "webview_height_ratio": "tall",
#             "fallback_url": "https://peterssendreceiveapp.ngrok.io/"
#           },
#           "buttons":[
#             {
#               "type":"web_url",
#               "url":"https://petersfancybrownhats.com",
#               "title":"View Website"
#             },{
#               "type":"postback",
#               "title":"Start Chatting",
#               "payload":"DEVELOPER_DEFINED_PAYLOAD"
#             }              
#           ]      
#         }
#       ]
#     }
#   }
# }