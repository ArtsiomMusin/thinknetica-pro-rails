# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ThinkneticaQna
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_spec: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_spec: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 1.hour }
  end
end
