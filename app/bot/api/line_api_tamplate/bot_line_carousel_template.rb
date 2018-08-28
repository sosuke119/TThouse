class BotLineCarouselTemplate
  
  def self.new( elements:nil )

    {
      "type": "template",
      "altText": "this is a carousel template",
      "template": {
        "type": "carousel",
        "columns": elements
      }
    }
  end


end