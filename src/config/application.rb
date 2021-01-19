require File.expand_path('../boot', __FILE__)

require 'log4r'
require 'log_formatter'
require 'log_formatter/log4r_json_formatter'

require 'rails/all'
require 'socket'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Notejam
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.log_level = :info
    config.colorize_logging = false
    hostname = Socket.gethostname
    logger = Log4r::Logger.new('notejam')
    outputter = Log4r::StderrOutputter.new(
      "console",
      :formatter => Log4r::JSONFormatter::Base.new('app', {'source': hostname})
    )
    logger.add(outputter)
    config.logger = logger
  end
end
