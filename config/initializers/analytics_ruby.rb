Analytics = AnalyticsRuby

unless ENV['analytics_key'].nil?
  Analytics.init(secret: ENV['analytics_key'],
                 on_error: Proc.new { |_status, msg| print msg })
end
