# -*- encoding : utf-8 -*-
Redu::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.logger = Logger.new("#{Rails.root}/log/mytest.log")
  # config.logger.level = 0
  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  config.assets.prefix = '/assets'

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Nome e URL do app
  config.url = "staging.openredu.com"

  config.action_mailer.default_url_options = { :host => config.url }
  config.action_mailer.asset_host = "http://#{config.url}"

  #settings SMTP
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 465,
    domain: "cin.ufpe.br",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "openredu@cin.ufpe.br",
    password: "3MH7diuFRKhhuFjhZgBK6Q==",
    openssl_verify_mode: "none"
  }


  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Configurações de VisClient
  config.vis_client = {
    :url => "http://vis.openredu.com/hierarchy_notifications.json",
  }

  config.vis = {
    :subject_activities => "http://vis.openredu.com/subjects/activities.json",
    :lecture_participation => "http://vis.openredu.com/lectures/participation.json",
    :students_participation => "http://vis.openredu.com/user_spaces/participation.json"
  }
end
