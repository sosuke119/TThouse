class LineController < ApplicationController
  require 'line/bot'
  # 開放api給第三方瀏覽
  skip_before_action :verify_authenticity_token, only: [:callback]


  def callback
    @request     ||= request
    @line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token  = ENV['line_channel_token']
    }

    varify_signature

    body   = @request.body.read
    events = @line_client.parse_events_from(body)

    events.each do |event|
      puts event['source']
      user  = BotUser.new(
        source: event['source'], 
        platform: 'line'
      ).user

      source = BotLineMessage.new(event)

      bot_message_controller = BotMessagesController.new(
        user:user,
        source:source,  
        platform: 'line'
      )
      reply_lines = bot_message_controller.reply
      puts "reply_lines #{reply_lines}"
      
      unless reply_lines.blank?
        @line_client.reply_message(event['replyToken'], reply_lines)
        # reply_lines.each do |reply|
        #   send_reply = @line_client.reply_message(event['replyToken'], reply)
        #   puts send_reply.body
        # end
      end
    end
    render plain: 200

  end

  def varify_signature
    body = @request.body.read
    signature = @request.env['HTTP_X_LINE_SIGNATURE']
    return '400 Bad Request' unless @line_client.validate_signature(body, signature)
  end

end
