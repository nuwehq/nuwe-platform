require 'rails_helper'

describe V3::IngredientGroupsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:ingredient_group) { FactoryGirl.create :ingredient_group }
  let! (:ingredient) { FactoryGirl.create :ingredient, ingredient_group: ingredient_group }
  let! (:usda_service) { FactoryGirl.create :usda_service}

  describe "incorrect service" do

    it "returns an error" do
      get "/v3/ingredient_groups.json", nil, bearer_auth
      expect(response.status).to eq(401)
      expect(json_body["error"]).to be_present
    end
  end

  describe "correct service" do

    before do
      FactoryGirl.create :capability, service_id: usda_service.id, application_id: oauth_application.id 
    end

    it "returns status 200 with a bearer auth" do
      get "/v3/ingredient_groups.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns status 200 by passing in app_id & app_secret" do
      get "/v3/ingredient_groups.json", nil, application_auth
      expect(response.status).to eq(200)
    end

    it "returns status 401 by passing a wrong app_id & app_secret" do
      get "/v3/ingredient_groups.json", nil, invalid_app_auth
      expect(response.status).to eq(401)
    end

    it "returns all ingredient groups" do
      get "/v3/ingredient_groups.json", nil, bearer_auth
      expect(json_body["ingredient_groups"]).to be_present
      expect(ingredient.ingredient_group.id).to eq(ingredient_group.id)
    end

  end

end
