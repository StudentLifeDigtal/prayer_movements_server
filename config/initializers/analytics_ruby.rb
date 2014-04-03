Analytics = AnalyticsRuby       # Alias for convenience

unless ENV['analytics_key'].nil?
	Analytics.init({
	    secret: ENV['analytics_key'],          # The write key for slnz/prymv
	    on_error: Proc.new { |status, msg| print msg }  # Optional error handler
	})
end