# spec/requests/api/oauth_spec.rb
require 'spec_helper'
require 'rack/oauth2'

describe 'OAuth' do

  describe 'auth ok' do
    let(:auth) { authenticate }
    it 'success' do
      expect(auth[:access_token]).to_not be_expired
    end
  end

  describe 'auth not ok' do
    context 'due to expired token' do
      let(:auth) { authenticate }
      it 'respond with error' do
        server_token = auth[:app].
                                  access_tokens.
                                  find_by resource_owner_id: auth[:user].id
        server_token.expires_in = 0
        server_token.save!
        get '/api/v1/movements.json',
            'access_token' => auth[:access_token].try(:token)
        expect(
               json['error_description']
               ).to eq('Token is expired. '\
                       'You can either do re-authorization or token refresh.')
      end
    end

    context 'due to revoked token' do
      let(:auth) { authenticate }
      it 'respond with error' do
        server_token = auth[:app].
                                  access_tokens.
                                  find_by resource_owner_id: auth[:user].id
        server_token.revoked_at = 1.minute.ago
        server_token.save!
        get '/api/v1/movements.json',
            'access_token' => auth[:access_token].try(:token)
        expect(
               json['error_description']
               ).to eq('Token was revoked. '\
                       'You have to re-authorize from the user.')
      end
    end

    context 'due to invalid credentials' do
      it 'respond with error' do
        expect { authenticate(1234) }.to raise_error(OAuth2::Error)
      end
    end
  end
end
