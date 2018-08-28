class BotUser

  attr_accessor :user

  def initialize( message:nil, source:nil, platform:nil )

    @message  = message
    @source   = source
    @platform = platform
  

    case @platform
    when 'facebook'
      init_facobook
    when 'line'
      init_line
    end


    init_user

  end

  def init_line
    line_uid = @source['userId']

    return if line_uid.blank?
    
    @info_hash = { 
      line_uid:line_uid,
      source: @platform
    }
  end

  def init_facobook
    if @source == 'message' or @source == 'postback'
      sender_id   = @message.sender["id"]
      fanpage_id  = @message.recipient["id"]
    else
      sender_id   = @message.recipient["id"]
      fanpage_id  = @message.sender["id"]
    end


    @info_hash = { 
      sender_id: sender_id, 
      fanpage_id: fanpage_id,
      source: @platform
    }
    
  end

  def init_user
    @user = User.where( @info_hash ).first
    
    if @user.present?
      @user.update(last_active_at: Time.zone.now) 
    else
      @user = User.create!( @info_hash )
    end 
  end

  
  
end