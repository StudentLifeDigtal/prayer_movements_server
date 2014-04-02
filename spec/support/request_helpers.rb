module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module OAuthHelpers
  	def authenticate
		  app = FactoryGirl.create :application
		  user = FactoryGirl.create :user
		  client = OAuth2::Client.new(app.uid, app.secret) do |b|
	      b.request :url_encoded
	      b.adapter :rack, Rails.application
	    end
	    access_token = client.password.get_token user.email, user.password
	    
	    {user: user, token: access_token.token}
		end
  end
end