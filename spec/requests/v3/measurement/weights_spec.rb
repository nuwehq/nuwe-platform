require 'rails_helper'

describe Measurement::WeightsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "create" do
    it "returns 201 created" do
      post "/v3/measurement/weights.json", {measurement: {value: 88000, date: Date.current, timestamp: Time.current, unit: "g", source: "nuapi"}}, bearer_auth
      expect(response.status).to eq(201)
    end

    it "creates a weight measurement" do
      expect {
        post "/v3/measurement/weights.json", {measurement: {value: 88000, date: Date.current, timestamp: Time.current, unit: "g", source: "nuapi"}}, bearer_auth
      }.to change(oauth_user.weight_measurements, :count).by(1)
    end

    it "needs a date" do
      post "/v3/measurement/weights.json", {measurement: {value: 88000, timestamp: Time.current, unit: "g", source: "nuapi"}}, bearer_auth
      expect(response.status).to eq(406)
    end

    it "needs a unit" do
      post "/v3/measurement/weights.json", {measurement: {value: 88000, date: Date.current, timestamp: Time.current, source: "nuapi"}}, bearer_auth
      expect(response.status).to eq(406)
    end

    it "needs a source" do
      post "/v3/measurement/weights.json", {measurement: {value: 88000, date: Date.current, timestamp: Time.current, unit: "g"}}, bearer_auth
      expect(response.status).to eq(406)
    end
  end

  describe "index" do
    before do
      FactoryGirl.create_list :weight_measurement, 3, user: oauth_user
    end

    it "returns status 200" do
      get "/v3/measurement/weights.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns measurements" do
      get "/v3/measurement/weights.json", nil, bearer_auth
      expect(json_body["weights"]).to be_present
    end

    it "is a paginated list" do
      get "/v3/measurement/weights.json?per_page=1", nil, bearer_auth
      expect(json_body["weights"].length).to eq(1)
    end
  end

end
