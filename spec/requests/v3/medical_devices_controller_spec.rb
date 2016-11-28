require 'rails_helper'

describe V3::DeviceResultsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:medical_device) { FactoryGirl.create :medical_device, application_id: oauth_application.id }

  before do
    oauth_user.profile.update FactoryGirl.attributes_for :profile_female
    Nu::Score.new(oauth_user).daily_scores(Date.current)
  end

  #application_auth

  describe "index action" do
    it "returns correct results" do
      get "/v3/medical_devices.json", nil, bearer_auth
      expect(json_body["medical_devices"]).to be_present
      expect(response.status).to eq(200)
    end
    it "returns correct results" do
      get "/v3/medical_devices.json", nil, application_auth
      expect(json_body["medical_devices"]).to be_present
      expect(response.status).to eq(200)
    end
    it "is a paginated list" do
      3.times { FactoryGirl.create :medical_device, application_id: oauth_application.id }
      get "/v3/medical_devices.json?per_page=1", nil, bearer_auth
      expect(json_body["medical_devices"].length).to eq(1)
    end
    it "you can go through the pages" do
      get "/v3/medical_devices.json?page=2", nil, application_auth
      expect(json_body["medical_devices"].length).to eq(0)
    end
  end
end
