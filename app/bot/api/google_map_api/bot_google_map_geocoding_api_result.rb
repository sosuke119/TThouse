class BotGoogleMapGeocodingApiResult

  attr_accessor :score, :area, :city, :road, :state, :coordinate, :full_address

  def initialize(result_hash,address_hash)

    address_hash ||= Hash.new
    
    @address_components = result_hash["address_components"]

    @full_address = result_hash["formatted_address"]
    @coordinate   = result_hash["geometry"]["location"]
    @score        = 0
    
    @address_components.each do |hash|

      add_name = hash["short_name"]

      if hash["types"].include?("administrative_area_level_3")
        @area   = add_name
        @score += 1 if @area.present? && address_hash[:area].present? && @area.include?(address_hash[:area])

      elsif hash["types"].include?("administrative_area_level_1")
        @city = add_name
        @score += 1 if @city.present? && address_hash[:city].present? && @city.include?(address_hash[:city])
      
      elsif hash["types"].include?("route")
        @road = add_name
        @score += 1 if @road.present? && address_hash[:road].present? && @road.include?(address_hash[:road])

      elsif hash["types"].include?("country")
        @state = add_name
        @score += 1 if @state.present? && address_hash[:state].present? && @state.include?(address_hash[:state])
      else

      end
    end

  end

end
