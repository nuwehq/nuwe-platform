require 'rails_helper'

describe V3::UsdaIngredientsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:usda_service) { FactoryGirl.create :usda_service}
  let! (:ingredient) { FactoryGirl.create :usda_ingredient }

  describe "incorrect service" do
    it "returns an error" do
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(response.status).to eq(401)
      expect(json_body["error"]).to be_present
    end
  end

  describe "correct service" do
    before do
      FactoryGirl.create :capability, service_id: usda_service.id, application_id: oauth_application.id
    end

    it "returns status 200 with a bearer auth" do
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns status 200 by passing in app_id & app_secret" do
      get "/v3/usda_ingredients.json", nil, application_auth
      expect(response.status).to eq(200)
    end

    it "returns status 401 by passing a wrong app_id & app_secret" do
      get "/v3/usda_ingredients.json", nil, invalid_app_auth
      expect(response.status).to eq(401)
    end
  end

  describe "get all USDA ingredients" do
    before do
      FactoryGirl.create :capability, service_id: usda_service.id, application_id: oauth_application.id
    end

    it "returns JSON response" do
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(response.header['Content-Type']).to include("application/json")
      expect(json_body["usda_ingredients"]).to be_present
    end

    it "contains only the keys we want present for USDA ingredients" do
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(json_body["usda_ingredients"].first.keys).not_to include("ingredient_group_id")
      expect(json_body["usda_ingredients"].first.keys).not_to include("small_portion")
      expect(json_body["usda_ingredients"].first.keys).to include("id")
      expect(json_body["usda_ingredients"].first.keys).to include("name")
      expect(json_body["usda_ingredients"].first.keys).to include("summary")
      expect(json_body["usda_ingredients"].first.keys).to include("detailed")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("proximates")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("minerals")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("vitamins")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("lipids")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("other")
      expect(json_body["usda_ingredients"].first["detailed"].keys).to include("portions")
    end

    it "only returns USDA ingredients and not simple ingredients" do
      ingredient_group = FactoryGirl.create :ingredient_group
      simple_ingredient = FactoryGirl.create :simple_ingredient, ingredient_group: ingredient_group
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(json_body["usda_ingredients"].length).to eq(1)
    end

    it "returns USDA ingredient information" do
      get "/v3/usda_ingredients.json", nil, bearer_auth
      expect(json_body["usda_ingredients"].first["id"]).to eq(ingredient.id)
      expect(json_body["usda_ingredients"].first["detailed"]["proximates"]["water"]).to eq("0.796400")
      expect(json_body["usda_ingredients"].first["detailed"]["minerals"]["iron"]).to eq("0.001600")
      expect(json_body["usda_ingredients"].first["detailed"]["vitamins"]["thiamin"]).to eq("0.000330")
      expect(json_body["usda_ingredients"].first["detailed"]["lipids"]["cholesterol"]).to eq("0.130000")
      expect(json_body["usda_ingredients"].first["detailed"]["portions"]["4.0 oz"]).to eq("113.0")
    end
  end
end
