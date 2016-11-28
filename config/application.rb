require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nuapi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'


    # Be sure to have the adapter's gem in your Gemfile
    # and follow the adapter's specific installation
    # and deployment instructions.
    config.active_job.queue_adapter = :sidekiq


    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = "en-GB"

    config.middleware.use Rack::Attack

    # Currently, Active Record suppresses errors raised within after_rollback or after_commit
    # callbacks and only prints them to the logs. In the next version, these errors will no
    # longer be suppressed. Instead, the errors will propagate normally just like in other
    # Active Record callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # use the memory store for all environments.
    # TODO replace by redis
    config.cache_store = :memory_store

    config.to_prepare do
      # Only Applications list
      Doorkeeper::ApplicationsController.layout "application"

      # Only Authorization endpoint
      Doorkeeper::AuthorizationsController.layout "authorizations"

      # Only Authorized Applications
      Doorkeeper::AuthorizedApplicationsController.layout "doorkeeper_application"
    end
  end
end
