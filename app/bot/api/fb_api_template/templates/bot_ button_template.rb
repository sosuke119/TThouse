class BotButtonTemplate

  def self.new( text: nil , buttons: nil )
  
    { 
      attachment: { 
        type: 'template', 
        payload: { 
          template_type: 'button',
          text: text,
          buttons: buttons
        } 
      }
    }

  end

end