require 'rails_helper'

describe V3::DevicesController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let(:apns_token) { "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>" }

  describe "create" do

    it_behaves_like "an authenticated V3 resource" do
      before do
        post "/v3/devices.json", {device: {token: apns_token}}
      end
    end

    it "creates a device" do
      expect {
        post "/v3/devices.json", {device: {token: apns_token}}, bearer_auth
      }.to change(Device, :count).by(1)
    end

    it "shows all devices" do
      post "/v3/devices.json", {device: {token: apns_token}}, bearer_auth
      expect(json_body["devices"].count).to eq(1)
      expect(json_body["devices"].first["token"]).to eq(apns_token.to_s)
    end

    it "takes a device from someone else" do
      other = FactoryGirl.create :user
      FactoryGirl.create :device, token: apns_token, user: other
      expect {
        post "/v3/devices.json", {device: {token: apns_token}}, bearer_auth
      }.to_not change(Device, :count)
    end
  end

  describe "index" do

    it_behaves_like "an authenticated V3 resource" do
      before do
        get "/v3/devices.json"
      end
    end

    it "shows all devices" do
      FactoryGirl.create :device, user: oauth_user
      get "/v3/devices.json", nil, bearer_auth
      expect(json_body["devices"].count).to eq(1)
      expect(json_body["devices"].first["token"]).to eq(apns_token.to_s)
    end

  end

end
