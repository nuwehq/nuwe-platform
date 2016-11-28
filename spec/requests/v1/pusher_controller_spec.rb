require 'rails_helper'

describe V1::AuthController do

  include_context "signed up user"
  include_context "api token authentication"

  describe "pusher" do

    it_behaves_like "an authenticated resource" do
      before do
        post "/v1/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{user.id}"
      end
    end

    it "returns ok" do
      post "/v1/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{user.id}", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "returns auth code" do
      post "/v1/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{user.id}", nil, token_auth
      expect(json_body["auth"]).to be_present
    end

    it "returns unauthorized for someone else's channel name" do
      other = FactoryGirl.create :user
      post "/v1/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{other.id}", nil, token_auth
      expect(response.status).to eq(401)
    end

    it "returns not found for an unknown channel name" do
      random = SecureRandom.hex(16)
      post "/v1/pusher/auth.json?socket_id=123.456&channel_name=#{random}", nil, token_auth
      expect(response.status).to eq(404)
    end
  end
end
