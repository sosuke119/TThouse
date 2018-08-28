class BotSession


  def self.create_and_fill_session_slots(bot_message,session)

    session_slots = []
    session.trigger.slots.each do |slot|
      attr_hash = {
        session_id:session.id,  
        slot_id:   slot.id,
        name:      slot.name,
        required:  slot.required,
        slot_type: slot.slot_type,
        is_hint:   slot.is_hint,
      }

      session_slots << SessionSlot.new(attr_hash)
    end

    bot_session_slot_controller = BotSessionSlotController.new(bot_message:bot_message, session:session, session_slots:session_slots,processor:'init')

    session_slots_objects = bot_session_slot_controller.session_slots_objects

    positions = session_slots_objects.map{ |ss| ss.position }
    session_slots_objects.each do |session_slot| 
      next if session_slot.value.blank? && session_slot.required == false
      session_slot.save! 
    end
  end


  def self.slots_all_filled(session)
    
    if session.session_slots.size == 0
      true
    elsif session.session_slots.required_but_empty.size == 0
      true
    else
      false
    end
  end


  def self.fill_new_slot(bot_message,session)
    session_slots = session.session_slots
    session_slot  = session.session_slots.required_but_empty.first

    if self.check_hint(bot_message, session_slot)
      true
    else
      # return true or false
      bot_session_slot_controller = BotSessionSlotController.new(
        bot_message:bot_message,
        session:session,
        session_slots:session_slots, 
        session_slot:session_slot,
        processor:'update')

      bot_session_slot_controller.session_slot_updated
    end
  end

  def self.check_hint(bot_message, session_slot)
    
    return unless session_slot.is_hint

    no_button_present = bot_message.payload_name == 'cancel_session_slot_required'
    no_words_present  = ['沒有','不用'].include?(bot_message.text)
    
    if no_button_present or no_words_present
      session_slot.update(required:false)
      true
    else
      false
    end
    
  end


end