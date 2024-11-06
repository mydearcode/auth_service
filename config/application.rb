require_relative "boot"

require "rails"
# Pick the frameworks you're using:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module AuthService
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Configuration for the application, engines, and railties goes here.
    config.api_only = true

    # Use Rack::Attack
    config.middleware.use Rack::Attack

    # Prevent frozen array issues
    config.autoload_paths += [
      Rails.root.join('app', 'services'),
      Rails.root.join('lib')
    ]
  end
end
