# spec/requests/api/oauth_spec.rb
require 'spec_helper'

describe 'OAuth authorization' do
  let(:app) { FactoryGirl.create :application }
  let(:user) { FactoryGirl.create :user }

  let(:client) do
    OAuth2::Client.new(app.uid, app.secret) do |b|
      b.request :url_encoded
      b.adapter :rack, Rails.application
    end
  end

  it 'auth ok' do
    token = client.password.get_token(user.email, user.password)
    expect(token).to_not be_expired
  end

  it 'auth not ok' do
    expect \
      { client.password.get_token(user.email, '123') }.to \
      raise_error(OAuth2::Error)
  end
end
