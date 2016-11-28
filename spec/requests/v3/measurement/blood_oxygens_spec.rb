require 'rails_helper'

describe Measurement::BloodOxygensController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "create" do
    it "returns 201 created" do
      post "/v3/measurement/blood_oxygens.json", {measurement: {value: 96.5, date: Date.current, timestamp: Time.current}}, bearer_auth
      expect(response.status).to eq(201)
    end

    it "creates a blood_oxygen measurement" do
      expect {
        post "/v3/measurement/blood_oxygens.json", {measurement: {value: 96.5, date: Date.current, timestamp: Time.current}}, bearer_auth
      }.to change(oauth_user.blood_oxygen_measurements, :count).by(1)
    end

    it "needs a date" do
      post "/v3/measurement/blood_oxygens.json", {measurement: {value: 96.5, timestamp: Time.current}}, bearer_auth
      expect(response.status).to eq(406)
    end
  end

  describe "index" do
    before do
      FactoryGirl.create_list :blood_oxygen_measurement, 3, user: oauth_user
    end

    it "returns status 200" do
      get "/v3/measurement/blood_oxygens.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns measurements" do
      get "/v3/measurement/blood_oxygens.json", nil, bearer_auth
      expect(json_body["blood_oxygens"]).to be_present
    end

    it "is a paginated list" do
      get "/v3/measurement/blood_oxygens.json?per_page=1", nil, bearer_auth
      expect(json_body["blood_oxygens"].length).to eq(1)
    end
  end

end
