class BotMenuTemplate
  
  def self.menu

    generics = []     

    generics << self.home_page_generic

    generics << self.media_generic

    [
      BotGenericTemplate.new(elements:generics)
    ]
  end

  def self.media
    generics = []

    generics << self.media_generic

    [
      BotGenericTemplate.new(elements:generics)
    ]
  end

  def self.home_page
    generics = []

    generics << self.home_page_generic

    [
      BotGenericTemplate.new(elements:generics)
    ]
  end

private

  def self.media_generic
    BotGeneric.new(
      title:          "推推志 - 一指觸動 地產新鮮事",
      image_url:      ENV["ROOT_URL"]+"/tt_media.png", 
      subtitle:       "實用軟硬知識，地產前瞻觀點，最有溫度的巷弄帶路人。",
      default_button: BotButton.new(button_type:'web_url', url: "https://media.tt.house"),
      buttons:        [BotButton.new(button_type:'web_url',title:'了解更多', url: "https://media.tt.house" )]
    )
  end

  def self.home_page_generic
    BotGeneric.new(
      title:          "關於我們 - 推推房 推什麼",
      image_url:      ENV["ROOT_URL"]+"/tt_about_us.png", 
      subtitle:       "以互聯網為基礎，線上導入線下; 獨創共享經濟機制，讓銷售更smart!",
      default_button: BotButton.new(button_type:'web_url', url: ENV['TBOT_HOME_PAGE']),
      buttons:        [BotButton.new(button_type:'web_url',title:'了解更多', url: ENV['TBOT_HOME_PAGE'] )]
    )
  end

end