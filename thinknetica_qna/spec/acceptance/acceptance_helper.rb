require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  config.include AcceptanceHelpers, type: :feature

  config.use_transactional_fixtures = false

  # basically for travis as it turns out to be slooow
  Capybara.default_max_wait_time = 20

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :deletion
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  OmniAuth.config.test_mode = true
  config.include(OmniauthMacros)
end
