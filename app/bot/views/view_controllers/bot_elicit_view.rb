class BotElicitView

  attr_accessor :reply

  def initialize(session_slot:nil, triggers:nil, session_state:nil, platform:nil)
    @session_slot  = session_slot
    @triggers      = triggers
    @session_state = session_state
    @platform      = platform

    set_reply_template
    set_data_hash
    set_template_controller
    set_reply
  end

  def set_reply_template
    case @session_state
    when 'elicit_slot'
      if @session_slot.slot_type == 'coordinate'
        @template_name = 'elicit_slot_coordinate'
      elsif @session_slot.is_hint
        @template_name = 'elicit_slot_hint'
      else
        @template_name = 'elicit_slot'
      end
    # when 'elicit_intent'
    # when 'confirm_slot'
    # when 'confirm_slot_and_elicit_intent'
    else
      @template_name  = @session_state
    end
  end

  def set_data_hash

    @data_hash = {
      session_slot: @session_slot,
      triggers: @triggers
    }
  end


  def set_template_controller
    @template_controller = BotElicitTemplate.new(
      @template_name, 
      @platform,
      @data_hash
    )
    @template = @template_controller.template
  end



  def set_reply
    @reply = @template

  end


end