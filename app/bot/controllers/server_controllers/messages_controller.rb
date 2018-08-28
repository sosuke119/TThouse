require "facebook/messenger"
include Facebook::Messenger
# include Devise::Controllers::Helpers

# 接受訊息
Bot.on :message do |message|

  

  user         = BotUser.new(message:message,source: 'message',platform: 'facebook').user

  puts "user.handed_over #{user.handed_over}"
  unless user.handed_over

    bot_message_controller = BotMessagesController.new(user:user,source:message, source_type:'message', platform: 'facebook')

    reply_lines = bot_message_controller.reply

    begin
    
      reply_lines.each_with_index do |reply,index|
        message.reply(reply)
      end

    rescue => error
      puts $!.message
      begin 
        puts $!.message
        message.reply({text:'哎呀，服務人員現在正在交接中，請耐心等候，謝謝您!'})
      rescue => error
      end
    end
  else

    BotChatroomController.new(user:user,source:message,source_type:'message')

  end
end


Bot.on :postback do |postback|

  user         = BotUser.new(message:postback,source:'postback',platform: 'facebook').user


  unless user.handed_over

    bot_message_controller = BotMessagesController.new(user:user, source:postback,source_type:'postback')
    reply_lines = bot_message_controller.reply


    begin
        
      reply_lines.each_with_index do |reply,index|
        postback.reply(reply)
      end
    rescue => error
      puts $!.message
      begin

        message.reply({text:'哎呀，服務人員現在正在交接中，請耐心等候，謝謝您!'})
      rescue => error
        puts $!.message
      end
    end
  end
end