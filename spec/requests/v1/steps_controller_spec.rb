require 'rails_helper'

describe "Steps API" do

  include_context "signed up user"
  include_context "api token authentication"

  describe "create" do

    let(:days) { {"2014-08-06" => 800, "2014-08-07" => 900} }

    it_behaves_like "an authenticated resource" do
      before do
        post "/v1/measurement/steps.json", steps: days
      end
    end

    it "accepts empty step-days" do
      expect {
        post "/v1/measurement/steps.json", {steps: {}}, token_auth
      }.to_not change(Measurement::Step, :count)
    end

    def do_post
      post "/v1/measurement/steps.json", {steps: days}, token_auth
    end

    it "accepts a hash of step-days" do
      expect {
        do_post
      }.to change(Measurement::Step, :count).by(2)
    end

    it "it will add m7 to the user's list of apps" do
      do_post
      expect(user.apps.map(&:provider)).to include("m7")
    end 

    it "returns 200 ok" do
      do_post
      expect(response.status).to eq(200)
    end

    it "contains the step-days in the response" do
      do_post
      expect(json_body["steps"].length).to eq(2)
      expect(json_body["steps"].first["value"]).to eq("800.0")
      expect(json_body["steps"].first["date"]).to eq("2014-08-06")
    end

    it "creates a historical score" do
      do_post
      historical_score = user.historical_scores.find_by(date: "2014-08-07")
      expect(historical_score).to_not be_nil
      expect(historical_score.activity).to_not eq(0)
    end
  end

  describe "index" do
    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/measurement/steps.json"
      end
    end

    it "is a paginated list" do
      FactoryGirl.create_list :step_measurement, 3, user: user
      get "/v1/measurement/steps.json?per_page=1", nil, token_auth
      expect(json_body["steps"].length).to eq(1)
    end

  end
end
