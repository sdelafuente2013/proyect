require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require_relative 'boot_utils'
Bundler.require(*Rails.groups)

module TolUsersApi
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = true
    config.encoding = 'utf-8'

    config.active_job.queue_adapter = :sidekiq

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :es
    config.i18n.fallbacks = [:en]
    I18n.available_locales = [:"es-MX", :"es-CO", :es, :ca, :en, :pt]
    config.i18n.fallbacks = {:"es-CO" => :"es", :"es-MX" => :"es", :"ca" => :"es", :"en" => :"es", :"pt" => :"es", :"es" => :"en"}

    config.autoload_paths += Dir["#{config.root}/app/models/helpers/**/"]
    config.autoload_paths += Dir["#{config.root}/app/lib/**/"]

    config.action_mailer.default_options = { from: %{"TOLUSERAPI" <toluserapi@tirant.com>} }
  end
end

RETRIES = YAML.load_file(Rails.root.join('config/retries.yml'))[Rails.env]
