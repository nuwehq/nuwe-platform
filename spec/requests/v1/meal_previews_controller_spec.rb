require 'rails_helper'

describe V1::MealPreviewsController do

  include_context "signed up user"
  include_context "api token authentication"

  let!(:turkey_whl_meat) { FactoryGirl.create :turkey_whl_meat }
  let!(:pasta_corn_cooked) { FactoryGirl.create :pasta_corn_cooked }
  let!(:carrots_raw) { FactoryGirl.create :carrots_raw }
  let!(:banana_raw) { FactoryGirl.create :banana_raw }

  # spaghetti test
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
    user.profile.update FactoryGirl.attributes_for :profile_female
  end

  context "without components" do
    it "has an error status code" do
      post "/v1/meal_previews.json", {meal_preview: {components: [] }}, token_auth
      expect(response.status).to eq(400)
    end
    it "returns an error message" do
      post "/v1/meal_previews.json", {meal_preview: {components: [] }}, token_auth
      expect(json_body["error"]).to be_present
    end
  end

  context "without dcn" do
    it "has an error status code" do
      post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 300}, {ingredient_id: carrots_raw.id, amount: 300}, {ingredient_id: pasta_corn_cooked.id, amount: 800}] }}, token_auth
      expect(response.status).to eq(404)
    end
    it "returns an error message" do
      post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 300}, {ingredient_id: carrots_raw.id, amount: 300}, {ingredient_id: pasta_corn_cooked.id, amount: 800}] }}, token_auth
      expect(json_body["error"]).to be_present
    end
  end

  context "with dcn" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_sergio
      Nu::Score.new(user).daily_scores(Date.current)
    end

    describe "create preview" do
      it "works" do
        post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 300}, {ingredient_id: carrots_raw.id, amount: 300}, {ingredient_id: pasta_corn_cooked.id, amount: 800}] }}, token_auth
        expect(json_body["nutrient_totals"]).to be_present
      end
      it "gives a different output for different amounts" do
        post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 1250}] }}, token_auth
        expect(json_body["prediction"]["difference"]).to eq(47)
      end
      it "can process a hundred kilos of raw carrots" do
        post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: carrots_raw.id, amount: 100000}] }}, token_auth
        expect(json_body["nutrient_totals"]["kcal"]).to eq("41000.0")
      end
    end


    describe "create preview for spaghetti test" do
      it "works" do
        post "/v1/meal_previews.json", {meal_preview: {components: [
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
        expect(json_body["nutrient_totals"]['protein']).to eq("56.281433")
        expect(json_body["nutrient_totals"]['fibre']).to eq("12.720228")
      end
    end


    describe "eaten one banana earlier" do
      before do
        eat = FactoryGirl.create :eat, user: user
        eat.components << Component.create([ingredient_id: banana_raw.id, amount: 120])
      end
      it "returns 616.400000 kcal" do
        post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 240}] }}, token_auth
        expect(json_body["predicted_nutrient_totals"]["kcal"]).to eq("616.4")
      end
    end

  end

  context "with empty value dcn" do
    it "has an error status code" do
      post "/v1/meal_previews.json", {meal_preview: {components: [{ingredient_id: turkey_whl_meat.id, amount: 300}, {ingredient_id: carrots_raw.id, amount: 300}] }}, token_auth
      expect(response.status).to eq(404)
    end

  end

end
