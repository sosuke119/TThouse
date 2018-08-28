class BotLocationController

  attr_accessor :reply

  def initialize( bot_message ) 
    puts 'Enter BotLocationController'
    @bot_message = bot_message

    self.action
    self.set_reply_tempalte
    self.set_reply
  end

  def action
    case @bot_message.route
    when 'set_location'
      
      slot_hashes  = @bot_message.slot_hashes

      if slot_hashes['新座標'].present?
        lat  = slot_hashes['新座標'][0]
        long = slot_hashes['新座標'][1]

        user = @bot_message.user
        user.assign_attributes( lat:lat, long:long)
        user.save if user.changed?
      end

    end
  end

  def set_reply_tempalte
    case @bot_message.route
    when 'set_location'
      @template = [{text: '成功紀錄你的位置！'}]
    end
  end

  def set_reply

    @reply = @template
    
  end

    
end