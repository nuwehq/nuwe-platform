require 'rails_helper'

describe V3::SimpleIngredientsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:usda_service) { FactoryGirl.create :usda_service}
  let! (:ingredient_group) { FactoryGirl.create :ingredient_group }
  let! (:ingredient) { FactoryGirl.create :simple_ingredient, ingredient_group: ingredient_group }

  describe "incorrect service" do
    it "returns an error" do
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(response.status).to eq(401)
      expect(json_body["error"]).to be_present
    end
  end

  describe "correct service" do
    before do
      FactoryGirl.create :capability, service_id: usda_service.id, application_id: oauth_application.id
    end

    it "returns status 200 with a bearer auth" do
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns status 200 by passing in app_id & app_secret" do
      get "/v3/simple_ingredients.json", nil, application_auth
      expect(response.status).to eq(200)
    end

    it "returns status 401 by passing a wrong app_id & app_secret" do
      get "/v3/simple_ingredients.json", nil, invalid_app_auth
      expect(response.status).to eq(401)
    end
  end

  describe "get Simple ingredients" do
    before do
      FactoryGirl.create :capability, service_id: usda_service.id, application_id: oauth_application.id
    end

    it "returns JSON response" do
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(response.header['Content-Type']).to include("application/json")
      expect(json_body["simple_ingredients"]).to be_present
    end

    it "contains the keys we want present for Simple ingredients" do
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(json_body["simple_ingredients"].first.keys).to include("ingredient_group_id")
      expect(json_body["simple_ingredients"].first.keys).to include("small_portion")
      expect(json_body["simple_ingredients"].first.keys).to include("medium_portion")
      expect(json_body["simple_ingredients"].first.keys).to include("large_portion")
      expect(json_body["simple_ingredients"].first.keys).to include("id")
      expect(json_body["simple_ingredients"].first.keys).to include("name")
      expect(json_body["simple_ingredients"].first.keys).to include("summary")
      expect(json_body["simple_ingredients"].first.keys).to include("detailed")
    end

    it "only returns Simple ingredients and not USDA ingredients" do
      usda_ingredient = FactoryGirl.create :usda_ingredient
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(json_body["simple_ingredients"].length).to eq(1)
    end

    it "returns Simple ingredient information" do
      get "/v3/simple_ingredients.json", nil, bearer_auth
      expect(json_body["simple_ingredients"].first["id"]).to eq(ingredient.id)
      expect(json_body["simple_ingredients"].first["ingredient_group_id"]).to eq(ingredient.ingredient_group_id)
      expect(json_body["simple_ingredients"].first["small_portion"]).to eq(ingredient.small_portion)
      expect(json_body["simple_ingredients"].first["medium_portion"]).to eq(ingredient.medium_portion)
      expect(json_body["simple_ingredients"].first["large_portion"]).to eq(ingredient.large_portion)
    end
  end

end
