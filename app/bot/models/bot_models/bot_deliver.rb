

class BotDeliver
  require "facebook/messenger"
  include Facebook::Messenger


    def initialize( user: nil ,message:nil, access_token: ENV['ACCESS_TOKEN'] )
      @user         = user
      @message      = message
      @access_token = access_token
    end

    def send
      

      begin
        Bot.deliver({
          recipient: { id: @user.sender_id },
          message: @message,
          message_type: Facebook::Messenger::Bot::MessageType::UPDATE
        }, access_token:@access_token )

        return 'Deliver Success'
      rescue StandardError => e
        puts "Deliver Failed => #{e} "
      end
        
    end

end