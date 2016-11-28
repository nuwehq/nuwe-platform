require 'rails_helper'

describe "Steps API" do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "create" do

    let(:days) { {"2014-08-06" => 800, "2014-08-07" => 900} }

    # it_behaves_like "an authenticated V3 resource" do
    #   before do
    #     post "/v3/measurement/steps.json", steps: days
    #   end
    # end

    it "accepts empty step-days" do
      expect {
        post "/v3/measurements.json", {steps: {}}, bearer_auth
      }.to_not change(Measurement::Activity, :count)
    end

    def do_post
      post "/v3/measurements.json", {steps: days}, bearer_auth
    end

    it "accepts a hash of step-days" do
      expect {
        do_post
      }.to change(Measurement::Activity, :count).by(2)
    end

    it "it will add m7 to the user's list of apps" do
      do_post
      expect(oauth_user.apps.map(&:provider)).to include("m7")
    end 

    it "returns 200 ok" do
      do_post
      expect(response.status).to eq(200)
    end

    it "contains the step-days in the response" do
      do_post
      expect(json_body["measurements"].length).to eq(2)
      expect(json_body["measurements"].first["steps"]).to eq(800)
      expect(json_body["measurements"].first["date"]).to eq("2014-08-06")
    end

    it "creates a historical score" do
      do_post
      historical_score = oauth_user.historical_scores.find_by(date: "2014-08-07")
      expect(historical_score).to_not be_nil
      expect(historical_score.activity).to_not eq(0)
    end
  end

  describe "index" do
    # it_behaves_like "an authenticated resource" do
    #   before do
    #     get "/v3/measurement/steps.json"
    #   end
    # end

    it "is a paginated list" do
      FactoryGirl.create_list :activity_measurement_steps, 3, user: oauth_user
      get "/v3/measurements.json?per_page=1", nil, bearer_auth
      expect(json_body["measurements"].length).to eq(1)
    end

  end
end
