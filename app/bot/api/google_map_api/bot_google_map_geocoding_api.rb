class BotGoogleMapGeocodingApi

  attr_accessor :coordinate, :top_scoring_result

  def initialize(address,address_hash)
    options = { query: { address: address,key: ENV['GOOGLE_MAP_KEY'],language: 'zh-TW' } }


    result = HTTParty.get( "https://maps.googleapis.com/maps/api/geocode/json",options)

    begin
      result_address_array = result.parsed_response["results"]
    rescue
      puts 'Google API Error'
    end

    @results_array     = []

    if result_address_array.present?
        
      result_address_array.each do |hash|
        @results_array << BotGoogleMapGeocodingApiResult.new(hash,address_hash)
      end
    end

    if @results_array.present? && @results_array.size > 0 
      @top_scoring_result = @results_array.sort_by { |h| -h.score }[0]
      @coordinate_hash    = @top_scoring_result.try(:coordinate)
    end

    self.set_coordinate

  end

  def set_coordinate
    @coordinate = @coordinate_hash.present? ? [ @coordinate_hash["lat"], @coordinate_hash["lng"] ] : nil
  end


end
