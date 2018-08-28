class BotProperty
   
  def self.avr_price_per_footage(properties)
    return nil if properties.blank?
    array = properties.map{ |property| property.sec_price unless property.sec_price.blank? or property.sec_price == 0  }.compact
    return nil if array.blank?
    (array.sum.to_f / array.size).round(2)
  end

  def self.avr_price_total(properties)
    return nil if properties.blank?
    array = properties.map{ |property| property.price unless property.price.blank? or property.price == 0 }.compact
    return nil if array.blank?
    (array.sum.to_f / array.size).round(2)
  end

end