Devise.setup do |config|
  config.secret_key = ENV['devise_secret_key']
  config.mailer_sender = 'admin@prayermovements.org'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.pepper = ENV['devise_pepper']
  config.reconfirmable = true
  config.password_length = 6..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
