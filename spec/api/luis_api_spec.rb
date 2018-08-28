require 'rails_helper'

RSpec.describe "Make sure LUIS API works fine. " do

  let :content do 
    '你好'
  end

  describe 'Luis' do 
    
    it '.query(content)' do
      result = Luis.query(content)
      expect(result.to_json.include?('message')).to be false
      expect(result.to_json.include?('intent')).to be true
    end
    
  end



end


