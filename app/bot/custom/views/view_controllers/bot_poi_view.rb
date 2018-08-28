class BotPoiView

  attr_accessor :reply

  def initialize(bot_message:nil, results:nil)
    @results  = results
    @platform = bot_message.platform || 'facebook'
    @bot_message = bot_message
    
    set_reply_template
    set_data_hash
    set_template_controller
    set_reply
  end

  def set_reply_template
    case @bot_message.route
    when 'search_poi','search_near_by_poi'
      @template_name  = 'search_poi'
    end
  end

  def set_data_hash

    @data_hash = {}

    case @template_name
    when 'search_poi'
      @data_hash[:results] = @results
    end

  end

  def set_template_controller

    @template_controller = BotPoiTemplate.new(
      @template_name, 
      @platform,
      @data_hash)
    @template = @template_controller.template
  end


  def set_reply
    
    @reply = @template
  end


end
