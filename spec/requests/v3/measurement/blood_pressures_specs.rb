require 'rails_helper'

describe Measurement::BloodPressuresController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "create" do
    it "returns 201 created" do
      post "/v3/measurement/blood_pressures.json", {measurement: {value: '120/90', date: Date.current, timestamp: Time.current}}, bearer_auth
      expect(response.status).to eq(201)
    end

    it "creates a blood pressure measurement" do
      expect {
        post "/v3/measurement/blood_pressures.json", {measurement: {value: '120/90', date: Date.current, timestamp: Time.current}}, bearer_auth
      }.to change(oauth_user.blood_pressure_measurements, :count).by(1)
    end

    it "needs a date" do
      post "/v3/measurement/blood_pressures.json", {measurement: {value: '120/90', timestamp: Time.current}}, bearer_auth
      expect(response.status).to eq(406)
    end
  end

  describe "index" do
    before do
      FactoryGirl.create_list :blood_pressure_measurement, 3, user: oauth_user
    end

    it "returns status 200" do
      get "/v3/measurement/blood_pressures.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns measurements" do
      get "/v3/measurement/blood_pressures.json", nil, bearer_auth
      expect(json_body["blood_pressures"]).to be_present
    end

    it "is a paginated list" do
      get "/v3/measurement/blood_pressures.json?per_page=1", nil, bearer_auth
      expect(json_body["blood_pressures"].length).to eq(1)
    end
  end

end
