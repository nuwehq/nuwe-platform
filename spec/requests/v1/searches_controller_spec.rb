require 'rails_helper'

describe V1::SearchesController do

  include_context "signed up user"
  include_context "api token authentication"
  include_context "throttle"

  describe "index" do

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/searches.json"
      end
    end

    it "returns status 200" do
      get "/v1/searches.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "is empty without users" do
      get "/v1/searches.json", nil, token_auth
      expect(json_body["searches"]).to be_empty
    end

    it "is a paginated list" do
      3.times { FactoryGirl.create :user }
      get "/v1/searches.json?per_page=1", nil, token_auth
      expect(json_body["searches"].length).to eq(1)
    end

  end

  describe "email" do

    let!(:other) { FactoryGirl.create :user }

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/searches.json", {search: {email: Faker::Internet.email}}
      end
    end

    it "returns status 200" do
      get "/v1/searches.json", {search: {email: other.email}}, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the user profile" do
      get "/v1/searches.json", {search: {email: other.email}}, token_auth
      expect(json_body["searches"].length).to eq(1)
      expect(json_body["searches"].first.keys).to include("id")
      expect(json_body["searches"].first.keys).to include("first_name")
      expect(json_body["searches"].first.keys).to include("avatar")
      expect(json_body["searches"].first.keys).to include("nu_score")
      expect(json_body["searches"].first.keys).to_not include("email")
    end

    it "allows empty result" do
      get "/v1/searches.json", {search: {email: "does not exist"}}, token_auth
      expect(json_body["searches"]).to be_empty
    end
  end

end
