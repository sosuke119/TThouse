require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tthouse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = "Taipei"

    # config.web_console.whiny_requests = false

    
    
    # Auto-load the bot and its subdirectories
    config.paths.add File.join('app', 'bot'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'bot', '*')]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOW-FROM https://www.facebook.com/',
      'X-Frame-Options' => 'ALLOW-FROM https://www.messenger.com/'
    }
  end
end
