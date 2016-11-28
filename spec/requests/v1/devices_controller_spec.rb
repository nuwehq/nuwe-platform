require 'rails_helper'

describe V1::DevicesController do

  include_context "signed up user"
  include_context "api token authentication"

  let(:apns_token) { "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>" }

  describe "create" do

    it_behaves_like "an authenticated resource" do
      before do
        post "/v1/devices.json", {device: {token: apns_token}}
      end
    end

    it "creates a device" do
      expect {
        post "/v1/devices.json", {device: {token: apns_token}}, token_auth
      }.to change(Device, :count).by(1)
    end

    it "shows all devices" do
      post "/v1/devices.json", {device: {token: apns_token}}, token_auth
      expect(json_body["devices"].count).to eq(1)
      expect(json_body["devices"].first["token"]).to eq(apns_token.to_s)
    end

    it "takes a device from someone else" do
      other = FactoryGirl.create :user
      FactoryGirl.create :device, token: apns_token, user: other
      expect {
        post "/v1/devices.json", {device: {token: apns_token}}, token_auth
      }.to_not change(Device, :count)
    end
  end

  describe "index" do

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/devices.json"
      end
    end

    it "shows all devices" do
      FactoryGirl.create :device, user: user
      get "/v1/devices.json", nil, token_auth
      expect(json_body["devices"].count).to eq(1)
      expect(json_body["devices"].first["token"]).to eq(apns_token.to_s)
    end

  end

end
