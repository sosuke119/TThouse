Bot.on :message_echo do |message_echo|
  message_echo.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
  message_echo.sender      # => { 'id' => '1008372609250235' }
  message_echo.seq         # => 73
  message_echo.sent_at     # => 2016-04-22 21:30:36 +0200
  message_echo.text        # => 'Hello, bot!'
  message_echo.attachments # => [ { 'type' => 'image', 'payload' => { 'url' => 'https://www.example.com/1.jpg' } } ]

  puts " echo done"

  user = BotUser.new(message:message_echo,source:'echo',platform: 'facebook' ).user

  if user.present?

    if user.handed_over

      BotChatroomController.new(user:user,source:message_echo,source_type:'echo')

    else

      hash = {
        user_id:          user.id,
        message_type:     'echo',
        text:             message_echo.text,
        echo_attachments: message_echo.attachments.to_json,
        sent_at:          message_echo.sent_at,
        seq:              message_echo.seq,
        mid:              message_echo.id
      }


      message_log = user.sessions.last.message_logs.new(hash) 

      if message_log.save!
        rendered_string = ApplicationController.render(
          template: 'message_logs/show.json',
          assigns: { message_log: message_log }
        )
        ActionCable.server.broadcast("board", { commit: 'addMessageLog', payload: rendered_string })

      end

    end

  end


end