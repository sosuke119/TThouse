# class HandOver 

#   include HTTParty

#   def initialize( domain: ENV['ROOT_URL'], access_token: ENV['ACCESS_TOKEN'])
#     @domain       = domain
#     @access_token = access_token
    
#   end

#   def user(user)
#     return unless user.present?
  
#     HTTParty.post(
#       "https://graph.facebook.com/v2.6/me/pass_thread_control?access_token=#{@access_token}", 
#       headers: { 'Content-Type' => 'application/json' },
#       body: {
#         "recipient": {"id": user.sender_id },
#         "target_app_id": ENV['CHAT_BOX_ID'],
#         "metadata": "轉接成功"
#       }
#     )

#   end

#   def take_it_back(user)
#      HTTParty.post(
#       "https://graph.facebook.com/v2.6/me/take_thread_control?access_token=#{@access_token}", 
#       headers: { 'Content-Type' => 'application/json' },
#       body: {
#         "recipient": {"id": user.sender_id },
#         "metadata": "取回成功"
#       }
#     )
#   end

#   def remote_user(sender_id, chat_box_id, access_token)
#     HTTParty.post(
#       "https://graph.facebook.com/v2.6/me/pass_thread_control?access_token=#{access_token}", 
#       headers: { 'Content-Type' => 'application/json' },
#       body: {
#         "recipient": {"id": sender_id },
#         "target_app_id": chat_box_id,
#         "metadata": "轉接成功"
#       }
#     )
#   end

#   def remote_take_it_back(sender_id,access_token)
#     HTTParty.post(
#       "https://graph.facebook.com/v2.6/me/take_thread_control?access_token=#{access_token}", 
#       headers: { 'Content-Type' => 'application/json' },
#       body: {
#         "recipient": {"id": sender_id },
#         "metadata": "取回成功"
#       }
#     )
#   end

# end