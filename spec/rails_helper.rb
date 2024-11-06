require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'

# Load all support files
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Database Cleaner configuration
  config.use_transactional_fixtures = true

  # Factory Bot configuration
  config.include FactoryBot::Syntax::Methods
  
  # Request helpers for controller specs
  config.include RequestHelpers, type: :controller
  
  # Include Rails route helpers
  config.include Rails.application.routes.url_helpers
  
  # Include ActiveSupport::Testing::TimeHelpers for time manipulation
  config.include ActiveSupport::Testing::TimeHelpers

  # Clean up ActionMailer deliveries
  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end 