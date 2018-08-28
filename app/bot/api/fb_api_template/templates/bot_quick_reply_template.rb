class BotQuickReplyTemplate


  def self.new( text: nil , quick_replies: nil )
  
    { 
      text: text,
      quick_replies: quick_replies
    }

  end

end

# "message":{
#   "text": text,
#   "quick_replies":[
#     {
#       "content_type":"text",
#       "title":"Search",
#       "payload":"<POSTBACK_PAYLOAD>",
#       "image_url":"http://example.com/img/red.png"
#     },
#     {
#       "content_type":"location"
#     },
#     {
#       "content_type":"text",
#       "title":"Something Else",
#       "payload":"<POSTBACK_PAYLOAD>"
#     }
#   ]
# }