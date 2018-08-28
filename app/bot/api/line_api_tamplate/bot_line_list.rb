class BotLineList
  
  def self.new( title:nil, subtitle:nil, button:nil)
    {
      type: 'text',
      text: "#{title}\n#{subtitle}\n#{button}"
    }
  end


end