require "facebook/messenger"
include Facebook::Messenger


# Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])


# 訂閱webhook時用
class BotFrameProvider < Facebook::Messenger::Configuration::Providers::Base

  def valid_verify_token?(verify_token)
    verify_token == ENV["VERIFY_TOKEN"] 
  end

  def app_secret_for(page_id) 
    ENV['APP_SECRET']
  end

  def access_token_for(page_id)
    ENV['ACCESS_TOKEN']
  end

end


Facebook::Messenger.configure do |config|
  config.provider = BotFrameProvider.new
end
