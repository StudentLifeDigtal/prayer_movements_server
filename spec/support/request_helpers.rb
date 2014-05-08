module Requests
  # json shorthand
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  # enabled requests to authenticate easily
  module OAuthHelpers
    def authenticate(password = nil)
      app = FactoryGirl.create :application
      user = FactoryGirl.create :user
      client = OAuth2::Client.new(app.uid, app.secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      access_token = client.password.get_token user.email,
                                               password || user.password
      { app: app, user: user, access_token: access_token, client: client }
    end
  end
end
