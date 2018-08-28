class BotRouteController

  attr_accessor :route, :controller_name

  def initialize(condition)
    @condition = condition

    self.set_route
    self.set_controller_name
  end

  def set_route
    # v 1.0.0
    case @condition
    when 'welcome'
      @route = 'welcome'

    when '查詢地點_房地產'
      @route = 'search_properties'

    when 'recommend_properties'
      @route = 'recommend_properties'

    when '傳送位置','set_location'
      @route = 'set_location'

    when '查詢價格'
      @route = 'average_price'

    when '服務列表'
      @route = 'services_list'

    when '查詢新聞_房地產'
      @route = 'tt_media'

    when '公司介紹'
      @route = 'tt_home_page'
    when '查詢地點'
      @route = 'search_poi'

    else
      @route = @condition
    end
  end

  def set_controller_name
    case @route
    when 'set_location'
      @controller_name = 'BotLocationController'

    when 'welcome'
      @controller_name = 'BotWelcomeController'

    when 'recommend_properties', 'search_properties' ,'average_price', 'show_more_properties'
      @controller_name = 'BotPropertyController'

    when 'services_list', "tt_media", "tt_home_page"
      @controller_name = 'BotMenuController'

    when 'handover_confirm', 'handover_done'
      @controller_name = 'BotHandOverController'
    when 'search_poi'
      @controller_name = 'BotPoiController'
    else
      @controller_name = 'BotConversationController'

    end


  end

  def self.function_buttons_list
    [
      'cancel',
      'recommend_properties',
      'set_location',
    ]
  end 

end