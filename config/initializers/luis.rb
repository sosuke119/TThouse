Luis.configure do |config|
  config.id = ENV['LUIS_ID']

  config.is_staging = 'false'

  config.subscription_key = ENV['LUIS_KEY']
end