class BotSessionController

  attr_accessor :controller , :reply, :session, :bot_message

  def initialize(bot_message)

    @bot_message = bot_message

    self.initialize_trigger
    self.initialize_session
    self.fill_slot_and_set_session
    self.update_session
    self.set_elicit_or_other_controllers
    self.set_reply
  end

  def initialize_trigger

    @bot_message_trigger_controller = BotMessageTriggerController.new(@bot_message)

    @bot_message.bot_luis        = @bot_message_trigger_controller.bot_luis
    @bot_message.tthouse_api_nlp = @bot_message_trigger_controller.tthouse_api_nlp
    @bot_message.trigger         = @bot_message_trigger_controller.trigger
    @bot_message.trigger_type    = @bot_message_trigger_controller.trigger_type

    @confirm_intent_id           = @bot_message_trigger_controller.confirm_intent_id

    case @bot_message.trigger_type
    when 'Intention'
      @bot_message.intention = @bot_message_trigger_controller.trigger
    when 'Payload'
      @bot_message.payload   = @bot_message_trigger_controller.trigger
    end
  end


  def initialize_session

    function_buttons = BotRouteController.function_buttons_list



    if @bot_message.session.present?
      if @bot_message.trigger.present? && ( function_buttons.include?(@bot_message.trigger.name) or @confirm_intent_id.present?)
        session_hash = Hash.new
        session_hash[:state]        = 'initialize'
        session_hash[:trigger_id]   = @confirm_intent_id if @confirm_intent_id.present?
        session_hash[:trigger_type] = 'Intention'        if @confirm_intent_id.present?

        @bot_message.session.update(finished_at: Time.zone.now)
        @session = @bot_message.user.sessions.create(session_hash)
        
      else
        @session = @bot_message.session
      end
    else
      @session = @bot_message.user.sessions.create(state:'initialize')
    end
    

    if @bot_message.trigger.present?
      @session.trigger ||= @bot_message.trigger
    end

    if @session.trigger.present? && @session.state == 'initialize'
      BotSession.create_and_fill_session_slots(@bot_message,@session)
    end

    @bot_message.session = @session

  end

  def fill_slot_and_set_session

    if @session.trigger.blank?
      @session.state = 'elicit_intent'
      return
    end

    if BotSession.slots_all_filled(@session)
      @session.state = 'ready'
      return
    end

    if @session.state == 'initialize'
      @session.state = 'elicit_slot'
      return
    end

    unless BotSession.fill_new_slot(@bot_message, @session)
     
       # 要填 Slot 時得到有可辨識 Intent 的回覆
      if @bot_message.trigger.present?
        @session.state = 'confirm_slot_and_elicit_intent'
        return
      else
        @session.state = 'confirm_slot'
        return
      end
    end

    if  BotSession.slots_all_filled(@session)
      @session.state = 'ready'
      return 
    else
      @session.state = 'elicit_slot'
      return 
    end

  end


  def update_session
    session_hash = {
      state:   @session.state,
      trigger: @session.trigger,
    }

    puts "Session : #{@session.inspect}"

    @session.update(session_hash)
  end

  def set_elicit_or_other_controllers
    if @session.state == 'ready'
      self.set_slot_hashes
      self.set_route
      self.set_controller
      self.close_session
    else
      @controller = BotElicitController.new(@bot_message)
    end
  end

  def set_slot_hashes
    
    session_slots = @session.session_slots
    slot_hashes  = []

    session_slots.each do |session_slot| 

      if session_slot.slot_type == "coordinate"
        value = nil
        begin 
          coor_array = JSON(session_slot.value)
          value = coor_array if coor_array.kind_of?(Array)
        rescue
        end
        slot_hashes << { session_slot.name => value }
      else
        slot_hashes << { session_slot.name => session_slot.value }
      end
    end
    

    @bot_message.slot_hashes = slot_hashes.reduce({}, :merge)
  end

  def set_route
    condition = @session.trigger.name
    @bot_route_controller = BotRouteController.new(condition)
    @bot_message.route    = @bot_route_controller.route

  end

  def close_session
    
    close = true

    case @bot_message.route
    when 'handover_confirm'
      close = false
    end
    
    @session.update(finished_at: Time.zone.now) if close

  end


  def set_controller
    controller_name = @bot_route_controller.controller_name
    @controller     =  controller_name.constantize.new(@bot_message)
  end

  def set_reply
    @reply = @controller.reply
  end

end