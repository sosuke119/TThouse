require 'rails_helper'

RSpec.describe "Make sure Tthouse API works fine. " do

  let :params do
    
  end

  subject { BotTthouseApi.new }

  describe 'Query Property.' do 
    it '.search_properties(params)' do
      result = subject.search_properties(nil)
      expect(result[0].title.present?).to be true
    end

    it '.recommend_properties(lat:nil, lon:nil, km:nil)' do
      result = subject.recommend_properties(lat:25.040859, lon:121.554958, km:2)
      expect(result[0].title.present?).to be true
    end

    it '.nlp(content)' do
      result = subject.nlp("我想找台北市忠孝東路上的住宅")
      expect(result[:intent].present?).to be true
    end
    
  end

end


