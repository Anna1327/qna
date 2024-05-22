require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoloader = :zeitwerk

    config.autoload_paths += [config.root.join('app')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_storage.replace_on_assign_to_many = false

    config.action_cable.disable_request_forgery_protection = false

    config.generators do |g|
      g.test_framework :rspec,
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_specs: true
    end
  end
end
