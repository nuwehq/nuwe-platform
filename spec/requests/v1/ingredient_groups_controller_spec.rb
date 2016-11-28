require 'rails_helper'

describe V1::IngredientGroupsController do

  describe "index" do

    let! (:ingredient_group) { FactoryGirl.create :ingredient_group }
    let! (:ingredient) { FactoryGirl.create :ingredient, ingredient_group: ingredient_group }

    it "returns status 200" do
      get "/v1/ingredient_groups.json"
      expect(response.status).to eq(200)
    end

    it "returns all ingredient groups" do
      get "/v1/ingredient_groups.json"
      expect(json_body["ingredient_groups"]).to be_present
      expect(ingredient.ingredient_group.id).to eq(ingredient_group.id)
    end

  end

end
