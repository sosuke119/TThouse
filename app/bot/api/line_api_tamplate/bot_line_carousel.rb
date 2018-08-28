class BotLineCarousel
  
  def self.new( title:nil, image_url:nil, text:nil,bgc:"#FFFFFF", buttons:nil)

    {
      "thumbnailImageUrl": image_url,
      "imageBackgroundColor": bgc,
      "title": title,
      "text": text,
      "actions": buttons
    }
  end

end