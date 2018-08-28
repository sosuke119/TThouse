class BotQuickReply
  
  def self.new( title: nil, payload: nil, image_url: nil, content_type: 'text')

    case content_type
    when 'location'
      {
        content_type: content_type
      }
    else
      {
        content_type: content_type,
        title: title,
        payload: payload
      }
    end
  end

  def self.cancel_bubble
    {
      content_type: 'text',
      title: '取消查詢',
      payload: BotPayload.new('cancel')
    }
  end

end

