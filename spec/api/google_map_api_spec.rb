require 'rails_helper'

RSpec.describe "Make sure Goolge Map API works fine. " do



  describe 'Query Address.' do 
    
    it '.address_to_coordinate(address, address_hash)' do
      result = BotGoogleMapGeocodeingApi.address_to_coordinate("台北市信義區信義路六段",{ city:'台北市',area: '信義區' })
      expect(result.present?).to be true
    end
    
  end



end


