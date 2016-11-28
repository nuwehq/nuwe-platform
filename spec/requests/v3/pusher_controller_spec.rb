require 'rails_helper'

describe V3::AuthController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "pusher" do

    it_behaves_like "an authenticated V3 resource" do
      before do
        post "/v3/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{oauth_user.id}"
      end
    end

    it "returns ok" do
      post "/v3/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{oauth_user.id}", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns auth code" do
      post "/v3/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{oauth_user.id}", nil, bearer_auth
      expect(json_body["auth"]).to be_present
    end

    it "returns unauthorized for someone else's channel name" do
      other = FactoryGirl.create :user
      post "/v3/pusher/auth.json?socket_id=123.456&channel_name=private-nuwe-#{other.id}", nil, bearer_auth
      expect(response.status).to eq(401)
    end

    it "returns not found for an unknown channel name" do
      random = SecureRandom.hex(16)
      post "/v3/pusher/auth.json?socket_id=123.456&channel_name=#{random}", nil, bearer_auth
      expect(response.status).to eq(404)
    end
  end
end
