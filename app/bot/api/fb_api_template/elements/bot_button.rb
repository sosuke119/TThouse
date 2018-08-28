class BotButton

  
  def self.new( url:nil, title:nil, button_type:'postback', payload:'postback_payload', webview_height_ratio: 'tall' )

    case button_type
    when 'web_url'
      {
        type: 'web_url',
        title: title,
        url: url,
        webview_height_ratio: webview_height_ratio
      }
    when 'webview'
    	{
        type: 'web_url',
        title: title,
        url: url,
        webview_height_ratio: webview_height_ratio,
        messenger_extensions: true
      }
    when 'postback'
			{
        type: 'postback',
        title: title,
        payload: payload
      }
    end

  end
end