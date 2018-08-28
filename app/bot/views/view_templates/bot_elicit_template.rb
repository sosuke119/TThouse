class BotElicitTemplate
  
  attr_accessor :template

  def initialize(template_name, platform, data_hash)
    @platform      = platform
    @template_name = template_name
    @data_hash     = data_hash

    set_variable
    set_template
  end

  def set_variable
    @session_slot   = @data_hash[:session_slot]

    case @template_name
    when 'elicit_slot'
      @text     = @session_slot.slot.slot_prompts.required.shuffle.first.try(:text)
      @text   ||= "請問是哪個 #{@session_slot.name} 呢？"

    when 'elicit_slot_hint'
      @text     = @session_slot.slot.slot_prompts.hint.shuffle.first.try(:text)
      @text   ||= "請問有指定的#{@session_slot.name}嗎？"
    when 'confirm_slot_and_elicit_intent'
      @triggers = @data_hash[:triggers]
      @text     = "抱歉，我無法辨識這個#{@session_slot.name}，可以請您再回答我一次嗎？"
    when 'confirm_slot'
      @text     = "抱歉，我無法辨識這個#{@session_slot.name}，可以請您再回答我一次嗎？"
    end

    
  end

  def set_template
    case @template_name
    when 'elicit_slot'

      @template = elicit_slot
    when 'elicit_slot_hint'
      
      @template = elicit_slot_hint

    when 'elicit_slot_coordinate'
      @template = elicit_slot_coordinate

    when 'confirm_slot'
      @template = confirm_slot

    when 'confirm_slot_and_elicit_intent'
      @template = confirm_slot_and_elicit_intent
    when 'elicit_intent'
      @template = BotHandOverView.handover_confirm(@platform)
    end
  end

  def elicit_slot_coordinate
    case @platform
    when 'facebook'
      [
        BotQuickReplyTemplate.new(
          text: '請點擊「Send Location」告訴我你的位置',
          quick_replies:[
            BotQuickReply.new(content_type: 'location'),
            BotQuickReply.cancel_bubble
          ]
        )
      ]
    when 'line'
      [
        BotLineConfirm.new(
          text: '請點擊「+」符號後，點擊「位置資訊」告訴我你的位置',
          actions:[
            BotLineButton.cancel_bubble,
            BotLineButton.cancel_bubble
          ]
        )
      ]
    end
  end

  def elicit_slot_hint
    case @platform
    when 'facebook'
      [
        BotQuickReplyTemplate.new(
          text: @text,
          quick_replies:[
            cancel_session_slot_required,
            BotQuickReply.cancel_bubble
          ]+ prompt_options
        )
      ]
    when 'line'
      [
        BotLineConfirm.new(
          text: @text,
          actions:[
            cancel_session_slot_required,
            BotLineButton.cancel_bubble
          ]
        )
      ]
    end
  end

  def elicit_slot
    case @platform
    when 'facebook'
      [
        BotQuickReplyTemplate.new(
          text: @text,
          quick_replies:[
            BotQuickReply.cancel_bubble
          ].compact + prompt_options
        )
      ]
    when 'line'
      [
        BotLineConfirm.new(
          text: @text,
          actions:[
            BotLineButton.cancel_bubble,
            BotLineButton.cancel_bubble
          ]
        )
      ]
    end
  end

  def confirm_slot_and_elicit_intent
    case @platform
    when 'facebook'
      [
        BotButtonTemplate.new(text: "您的意圖是以下的任何一種嗎", buttons: elicit_intent_buttons),
        BotQuickReplyTemplate.new(
          text: @text,
          quick_replies:[
            BotQuickReply.cancel_bubble
          ].compact + prompt_options
        )
      ]
    when 'line'
      [
        BotLineConfirm.new(
          text: @text,
          actions:[
            BotQuickReply.cancel_bubble,
            BotQuickReply.cancel_bubble
          ]
        )
      ]
      
    end
    
  end

  def confirm_slot
    case @platform
    when 'facebook'
      [
        BotQuickReplyTemplate.new(
          text: @text,
          quick_replies:[
            BotQuickReply.cancel_bubble
          ].compact + prompt_options
        )
      ]
    when 'line'
      [
        BotLineConfirm.new(
          text: @text,
          actions:[
            BotLineButton.cancel_bubble,
            BotLineButton.cancel_bubble
          ]
        )
      ]
    end
  end

  def prompt_options

    return [] if @session_slot.prompt_options.blank?
    options = JSON(@session_slot.prompt_options)
    return [] unless options.kind_of?(Array)
    
    options.first(5).map{ |option|
      BotQuickReply.new( 
        title: option,
        payload: BotPayload.new('prompt_option')
      )
    }
  end

  def cancel_session_slot_required
    case @platform
    when 'facebook'
      BotQuickReply.new( 
        title: '沒有',
        payload: BotPayload.new({
          name:'cancel_session_slot_required'}
        )
      )
    when 'line'
      BotLineButton.new( 
        text: '沒有',
        payload: BotPayload.new({
          name:'cancel_session_slot_required'}
        )
      )
    end
  end


  def elicit_intent_buttons
    case @platform
    when 'facebook'
      @triggers.map{ |intent| 
        BotButton.new( 
          title:intent.name, 
          payload:BotPayload.new(
            {name:'confirm_new_intent', 
              intent_id:intent.id}
          )
        ) 
      }
    when 'line'
      [{type:'text', text:@template_name}]
      
    end
      
  end

end