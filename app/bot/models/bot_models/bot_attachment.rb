class BotAttachment

  attr_accessor :message_log_id,
    :attachment_type,
    :url,
    :lat,
    :long

  def initialize(attachment_hash:nil, platform:nil)
    
    case platform
    when 'facebook'
      @message_log_id  = nil
      # @title           = attachment_hash.dig(:title)
      @attachment_type = attachment_hash.dig('type')
      @url             = attachment_hash.dig('payload', 'url')
      @lat             = attachment_hash.dig('payload', 'coordinates', 'lat').try(:to_d)
      @long            = attachment_hash.dig('payload', 'coordinates', 'long').try(:to_d)
    when 'line'
      @attachment_type = attachment_hash.dig('type')
      @lat             = attachment_hash.dig('latitude').try(:to_d)
      @long            = attachment_hash.dig('longitude').try(:to_d)
      #address
    end
  end



  def save(message_log_id)

    MessageAttachment.create!(
      message_log_id:  message_log_id,
      # title:           @title,
      attachment_type: @attachment_type,
      url:             @url,
      lat:             @lat,
      long:            @long
    )
  end




end