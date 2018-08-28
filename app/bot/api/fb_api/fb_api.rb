class FbApi

  include HTTParty

  def initialize( domain: ENV['ROOT_URL'], access_token: ENV['ACCESS_TOKEN'])
    @domain       = domain
    @access_token = access_token
    
  end
end 