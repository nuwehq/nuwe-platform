require 'rails_helper'

describe V1::EatsController do

  include_context "signed up user"
  include_context "api token authentication"

  let! (:eat) { FactoryGirl.create :eat, user: user }
  let! (:old_eat) { FactoryGirl.create :old_eat, user: user }
  let! (:ingredient) { FactoryGirl.create :ingredient }
  let! (:carrots_raw) { FactoryGirl.create :carrots_raw }
  let! (:turkey_whl_meat) { FactoryGirl.create :turkey_whl_meat }
  let! (:meal) { FactoryGirl.create :meal, user: user }
  let! (:product) { FactoryGirl.create :product }

  # spaghetti-test
  let! (:pepper) { FactoryGirl.create :pepper }
  let! (:salt) { FactoryGirl.create :salt }
  let! (:olive_oil) { FactoryGirl.create :olive_oil }
  let! (:rice) { FactoryGirl.create :rice }
  let! (:beef) { FactoryGirl.create :beef }
  let! (:mushrooms) { FactoryGirl.create :mushrooms }
  let! (:peppers) { FactoryGirl.create :peppers }
  let! (:tomatoes) { FactoryGirl.create :tomatoes }
  let! (:squash) { FactoryGirl.create :squash }
  let! (:carrot) { FactoryGirl.create :carrot }
  let! (:potato) { FactoryGirl.create :potato }
  let! (:onion_leeks) { FactoryGirl.create :onion_leeks }


  before do
    user.profile.update FactoryGirl.attributes_for :profile_sergio
    Nu::Score.new(user).daily_scores(Date.current)
  end

  describe "create" do
    it "accepts components" do
      expect {
        post "/v1/eats.json", {eat: { components: [{ingredient_id: ingredient.id, amount: 70}], meal_ids: [meal.id] } }, token_auth
      }.to change {
        user.eats.count
      }.by(1)
    end

    it "accepts meal-ids" do
      expect {
        post "/v1/eats.json", {eat: {meal_ids: [meal.id]}}, token_auth
      }.to change {
        user.eats.count
      }.by(1)
    end

    it "accepts products" do
      expect {
        post "/v1/eats.json", {eat: {product_ups: [product.upc]}}, token_auth
      }.to change {
        user.eats.count
      }.by(1)
    end

    before do
      user.profile.update FactoryGirl.attributes_for :profile
    end

    it "contains the eat in the response" do
      post "/v1/eats.json", {eat: {meal_ids: [meal.id]}}, token_auth
      expect(json_body["eat"]).to be_present
    end

    it "has a breakdown" do
      post "/v1/eats.json", {eat: {components: [{ingredient_id: carrots_raw.id, amount: 70}], meal_ids: [meal.id]}}, token_auth
      expect(json_body["eat"]["breakdown"]).to be_present
    end
  end

  describe "index action" do
    before do
      eat.components.create!(ingredient_id: ingredient.id, amount: 200)
      meal.components.create!(ingredient_id: ingredient.id, amount: 250)
      old_eat.meals << Meal.find(meal.id)
    end
    it "shows al my eats" do
      get "/v1/eats.json", nil, token_auth
      expect(json_body["eats"]).to be_present
      expect(response.status).to eq(200)
    end
    it "shows eaten meals" do
      get "/v1/eats.json", nil, token_auth
      expect(Eat.last.meal_ids).to include(meal.id)
    end

    it "is a paginated list" do
      3.times { FactoryGirl.create :eat, user: user }
      get "/v1/eats.json?per_page=1", nil, token_auth
      expect(json_body["eats"].length).to eq(1)
    end
  end

  describe "today's index" do
    it "shows all eats for today" do
      Eat.destroy_all
      3.times { FactoryGirl.create :yesterdays_eat, user: user }
      3.times { FactoryGirl.create :eat, user: user }
      get "/v1/eats/today.json", nil, token_auth
      expect(json_body["eats"].length).to eq(3)
    end
  end


  describe "edit" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile
    end
    it "returns a 200 status" do
      patch "/v1/eats/#{eat.id}.json", {eat: { components: [{ingredient_id: carrots_raw.id, amount: 70}], meal_ids: [meal.id] } }, token_auth
      expect(response.status).to eq(200)
    end

    it "contains correct ingredients" do
      patch "/v1/eats/#{eat.id}.json", {eat: { components: [{ingredient_id: turkey_whl_meat.id, amount: 240}]}}, token_auth
      expect(json_body["eat"]["breakdown"]["kcal_g"]).to eq("381.6")
    end

    it "can update an eaten product" do
      patch "/v1/eats/#{eat.id}.json", {eat: { product_upcs: [product.upc]}}, token_auth
      expect(json_body["eat"]["breakdown"]["kcal_g"]).to eq("200.0")
    end
  end

  describe "delete" do
    it_behaves_like "a nice 404 response" do
      before do
        delete "/v1/eats/teamsnowden.json", nil, token_auth
      end
    end

    it "returns a 200 status" do
      delete "/v1/eats/#{eat.id}.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "allows an eat to be deleted" do
      expect {
        delete "/v1/eats/#{eat.id}.json", nil, token_auth
      }.to change(Eat, :count).by(-1)
    end
  end

  describe "spaghetti test" do
    it "has the correct breakdown" do
      post "/v1/eats.json", {eat: {components: [
                            {ingredient_id: pepper.id, amount: 1},
                            {ingredient_id: salt.id, amount: 1},
                            {ingredient_id: olive_oil.id, amount: 5},
                            {ingredient_id: rice.id, amount: 120},
                            {ingredient_id: beef.id, amount: 240},
                            {ingredient_id: mushrooms.id, amount: 90},
                            {ingredient_id: peppers.id, amount: 90},
                            {ingredient_id: tomatoes.id, amount: 90},
                            {ingredient_id: squash.id, amount: 75},
                            {ingredient_id: carrot.id, amount: 60},
                            {ingredient_id: potato.id, amount: 75},
                            {ingredient_id: onion_leeks.id, amount: 40},
                                                ]}}, token_auth
      expect(json_body["eat"]["breakdown"]["protein_g"]).to eq("56.281433")
      expect(json_body["eat"]["breakdown"]["carbs_g"]).to eq("44.83044")
      expect(json_body["eat"]["breakdown"]["fibre_g"]).to eq("12.720228")
    end
  end

  describe "eating products" do
    before do
      Eat.destroy_all
    end
    it "has the correct breakdown" do
      post "/v1/eats.json", { eat: {product_upcs: [product.upc]}}, token_auth
      expect(json_body["eat"]["breakdown"]["kcal_g"]).to eq("200.0")
      expect(json_body["eat"]["breakdown"]["protein_g"]).to eq("3.0")
    end
  end

  describe "eat locations" do
    it "can create lat lon" do
      post "/v1/eats.json", { eat: {lat: 52.352108, lon: 4.890718 }}, token_auth
      expect(json_body["eat"]["lat"]).to eq("52.352108")
      expect(json_body["eat"]["lon"]).to eq("4.890718")
    end
    it "can update the lat lon" do
      patch "/v1/eats/#{eat.id}.json", { eat: {lat: 53.352108, lon: 4.890718 }}, token_auth
      expect(json_body["eat"]["lat"]).to eq("53.352108")
    end
    it "can create places" do
      post "/v1/eats.json", { eat: {places: [{name: "First place", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 52.352108, lon: 4.890718 }] }}, token_auth
      expect(json_body["eat"]["places"]).to_not be_empty
    end
    it "can create more than one place" do
      post "/v1/eats.json", { eat: {places: [{name: "First place", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 52.352108, lon: 4.890718},{name: "Second place", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 52.352108, lon: 4.890718}]}}, token_auth
      expect(json_body["eat"]["places"]).to_not be_empty
    end
    it "can update places" do
      patch "/v1/eats/#{eat.id}.json", { eat: {places: [{name: "Updated place", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 52.352108, lon: 4.890718 }] }}, token_auth
      expect(json_body["eat"]["places"]).to_not be_empty
      expect(response.status).to eq(200)
    end
  end

end
