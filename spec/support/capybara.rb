require 'capybara/rspec'
require 'capybara/rails'
require 'capybara-screenshot/rspec'

Capybara.app = DoctorStrange::Engine

RSpec.configure do |config|
  config.include DoctorStrange::Engine.routes.url_helpers
end
