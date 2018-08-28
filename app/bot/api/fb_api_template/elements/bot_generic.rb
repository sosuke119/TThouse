class BotGeneric
  
  def self.new( title:nil, image_url:nil, subtitle:nil, default_button:nil, buttons:nil)
    {
      
      title: title,
      image_url: image_url,
      subtitle: subtitle,
      default_action: default_button,
      buttons: buttons
    }
  end

end