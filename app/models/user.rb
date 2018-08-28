class User < ApplicationRecord

  validates_uniqueness_of :sender_id

  has_many :sessions, dependent: :destroy
  has_many :message_logs, dependent: :destroy
  has_many :message_attachments, through: :message_logs, dependent: :destroy

  has_many :chatroom_users, dependent: :destroy
  has_many :chatrooms, through: :chatroom_users

  acts_as_mappable :default_units => :kms,
                 :default_formula => :sphere,
                 :lat_column_name => :lat,
                 :lng_column_name => :long


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable,  :omniauth_providers => [:facebook]

  # before_create{ |action| action.get_fb_asid_with_chatbot_sender_id('new') }
  before_create{ |action| action.get_info_from_messenger('new') }


  scope :admins, -> { where( role:'admin' ).all}

  def handed_over
    if self.current_session.present?
      if self.current_session.state == 'handed_over'
        return true
      end
    end

    false
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end



  def current_session

    session             = self.sessions.last

    return nil unless session.present?
    
    # session_unfinished  = session.finished_at.blank?
    # session_not_expried = session.created_at + 20.minutes > Time.zone.now
    
    if session.unfinished && session.not_expried
      return session

    elsif session.unfinished == true && session.not_expried == false
      session.set_as_expired
      return nil

    else
      return nil
    end

  end

  def has_location
    self.long? && self.lat?
  end

  def coordinate_expired

    message_attachment = self.message_attachments.where(attachment_type:'location').last
    return true unless message_attachment.present?
    time = message_attachment.created_at
    return true unless time.present?
    ( time + 15.minutes) < Time.zone.now
  end

  def coordinate_array
    [self.lat, self.long]
  end


  # FB omniauth

  def self.from_omniauth(auth, param_sender_id)
    
    user   = User.where(fb_uid:auth.uid, provider:auth.provider).first

    # 已經有就讓她登入
    if user.present?


      user.provider = auth.provider
      user.fb_uid   = auth.uid
      user.email    = auth.info.email
      user.password = Devise.friendly_token[0,20]
      
    else


      begin
        sender_id_array = auth.extra.raw_info.ids_for_pages

        
        if sender_id_array.present?
          sender_id = sender_id_array.data.select{ |element| element.page.id.to_s  == ENV['PAGE_ID'] }.first.id
        end
      rescue
        sender_id = nil
      end

      sender_id ||= param_sender_id

      if sender_id.present?

        user = User.where(sender_id:sender_id).first


        if user.present? && user.fb_uid.blank?

          email = auth.info.email || '.'

          user.update(
            provider:auth.provider,
            fb_uid: auth.uid,
            email: email,
            password: Devise.friendly_token[0,20],
          )
        # else
        #   user.create(
        #     fb_uid:fb_uid,
        #     provider:auth.provider,
        #     email: email,
        #     password: Devise.friendly_token[0,20],
        #   )
        end
      end
      
    end
    return user
  end
  # FB omniauth END

  def get_fbid
    sender_id = self.sender_id
    
    uri       = URI("https://graph.facebook.com/#{sender_id}")
    
    param     = URI.encode_www_form({

      "fields" => "email, name, ids_for_pages, ids_for_apps",
      "access_token" => ENV['ACCESS_TOKEN']
    })

    if param.length > 0
      if uri.query && uri.query.length > 0
        uri.query += '&' + param
      else
        uri.query = param
      end
    end

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    puts response.body
  end


  # asid = app's_id for fb login
  def get_fb_asid_with_chatbot_sender_id(action)
    
    sender_id = self.sender_id
    
    uri       = URI("https://graph.facebook.com/#{sender_id}/ids_for_apps")
    
    param     = URI.encode_www_form({
      'app' =>  ENV['APP_ID'],
      "access_token" => ENV['ACCESS_TOKEN']
    })

    if param.length > 0
      if uri.query && uri.query.length > 0
        uri.query += '&' + param
      else
        uri.query = param
      end
    end

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end

    result = nil

    begin 
      result = JSON.parse(response.body,:symbolize_names => true)
    rescue SyntaxError => se
      puts 'RESCUED!'
    end

    puts "result: #{result}"


    if result.present? && result[:data].present? && result[:data].kind_of?(Array)
      fb_uid = result[:data].map{ |app_id_hash| app_id_hash.dig(:id) if app_id_hash.dig(:app,:id) == ENV['APP_ID'] }
      
      if fb_uid.kind_of?(Array) && fb_uid.size == 1
        action == 'update' ? self.update( fb_uid: fb_uid[0] ) : self.fb_uid = fb_uid[0]
      end
    end
    
  end

  def get_info_from_messenger(action)
    return unless sender_id.present?

    user_id = self.sender_id
    access_token = ENV['ACCESS_TOKEN']
  
    url = 'https://graph.facebook.com/v2.6/'+user_id+'?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token='+access_token
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    response_json = JSON.parse(response.body)

    if action == 'update'
      self.update(
        last_name:  response_json['last_name'],
        first_name: response_json['first_name'],
        gender:     response_json['gender'],
        profile_pic:response_json['profile_pic'],
        locale:     response_json['locale']
      )
    else
      self.last_name = response_json["last_name"]
      self.first_name = response_json["first_name"]
      self.gender = response_json["gender"]
      self.profile_pic = response_json["profile_pic"]
      self.locale = response_json["locale"]
    end
  end

end
