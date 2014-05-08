Airbrake.configure do |config|
  config.api_key = '293c0aec55ce6c76820bc3ed84429729'
  config.host    = 'errors.studentlife.org.nz'
  config.port    = 80
  config.secure  = config.port == 443
end
