require 'rails_helper'

describe V3::MealsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:nuwe_meals_service) { FactoryGirl.create :nuwe_meals_service}

  let! (:ingredient) { FactoryGirl.create :ingredient }
  let! (:carrots_raw) { FactoryGirl.create :carrots_raw }
  let! (:pasta_corn_cooked) { FactoryGirl.create :pasta_corn_cooked }

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
    oauth_user.profile.update FactoryGirl.attributes_for :profile_female
    Nu::Score.new(oauth_user).daily_scores(Date.current)
    FactoryGirl.create :capability, service_id: nuwe_meals_service.id, application_id: oauth_application.id
  end

  describe "all meals" do

    before do
      FactoryGirl.create_list :meal, 3, user: oauth_user
    end

    it "returns status 200" do
      get "/v3/meals/all.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns status 200 with application auth method" do
      get "/v3/meals/all.json", nil, application_auth
      expect(response.status).to eq(200)
    end

    it "returns all meals" do
      get "/v3/meals/all.json", nil, bearer_auth
      expect(json_body["meals"]).to be_present
    end

    it "is a paginated list" do
      get "/v3/meals/all.json?per_page=1", nil, bearer_auth
      expect(json_body["meals"].length).to eq(1)
    end

    it "is not my favourite" do
      get "/v3/meals/all.json", nil, bearer_auth
      expect(json_body["meals"].first["favourite"]).to be_falsy
    end

  end

  describe "my meals" do

    before do
      FactoryGirl.create_list :meal, 3, user: oauth_user
    end

    it "returns status 200 with a token" do
      get "/v3/meals.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns all my meals" do
      get "/v3/meals.json", nil, bearer_auth
      expect(oauth_user.meal_ids).to include(json_body["meals"].first["id"])
    end

    it "is a paginated list" do
      get "/v3/meals.json?per_page=1", nil, bearer_auth
      expect(json_body["meals"].length).to eq(1)
    end
  end

  describe "create" do

    it "works" do
      expect {
        post "/v3/meals.json", {meal: {name: "Apple pie", components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}] }}, bearer_auth
      }.to change(Meal, :count).by(1)
    end

    it "works with application auth method" do
      expect {
        post "/v3/meals.json", {meal: {name: "Apple pie", components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}] }}, application_auth
      }.to change(Meal, :count).by(1)
    end

    it "contains the correct ingredient id" do
      post "/v3/meals.json", {meal: {name: "Apple pie", components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
      expect(Component.last.ingredient_id).to eq(ingredient.id)
      expect(Component.last.amount).to eq(45)
      expect(Meal.last.name).to eq("Apple pie")
    end

    it "allows meal to be favorited" do
      expect {
        post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
      }.to change(Favourite, :count).by(1)
    end

    it "allows meal to have a type" do
      post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, type: 'breakfast', components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
      expect(json_body["meal"]["favourite"]).to eq(true)
      expect(json_body["meal"]["type"]).to eq("breakfast")
    end

    it "only allows certain meal types" do
      post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, type: 'brinner', components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
      expect(response.code).to eq("400")
    end

    context 'images' do

      let(:meal) { FactoryGirl.create :meal, user: oauth_user }

      def base64_image
        base64 = Base64.encode64(File.read('spec/uploads/meal.jpg'))
        "data:image/jpeg;base64,#{base64}"
      end

      it "stores the jpg" do
        expect {
          post "/v3/meals.json", {meal: {name: "Tomato", images: [base64_image] }}, bearer_auth
        }.to change(Image, :count).by(1)
      end
      it "updates an image" do
        expect {
          patch "/v3/meals/#{meal.id}.json", {meal: {name: "Tomato", images: [base64_image] }}, bearer_auth
        }.to change(Image, :count).by(1)
      end
    end

    context 'places' do
      let(:meal) { FactoryGirl.create :meal, user: oauth_user }

      it "accepts places to be added to the meal" do
        expect {
          post "/v3/meals.json", {meal: {name: "Meal with places", places: [{name: "First place", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }}, bearer_auth
        }.to change(Place, :count).by(2)
      end
      it "allows places to be updated" do
        expect {
          patch "/v3/meals/#{meal.id}.json", {meal: {name: "Meal with places", places: [{name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }}, bearer_auth
        }.to change(Place, :count).by(1)
      end
      it "ignores the update if there is no places param" do
        patch "/v3/meals/#{meal.id}.json", {meal: {name: "Meal with places", places: [{name: "Third place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }}, bearer_auth
        meal.reload
        patch "/v3/meals/#{meal.id}.json", {meal: {name: "Renaming the meal" }}, bearer_auth
        expect(json_body["meal"]["places"]).not_to be_empty
      end
      it "accepts a meal's own lat lon" do
        post "/v3/meals.json", {meal: {name: "Meal with lat lon", lat: 50.8571601, lon: -2.1645891}}, bearer_auth
        expect(json_body["meal"]["lat"]).to eq('50.8571601')
        expect(json_body["meal"]["lon"]).to eq('-2.1645891')
      end
      it "can update a meal's own lat lon" do
        patch "/v3/meals/#{meal.id}.json", {meal: {name: "Meal with lat lon", lat: 50.9999999, lon: -2.9999999}}, bearer_auth
        expect(json_body["meal"]["lat"]).to eq('50.9999999')
        expect(json_body["meal"]["lon"]).to eq('-2.9999999')
      end
    end
  end

  describe "create spaghetti test" do
    before do
      oauth_user.profile.update FactoryGirl.attributes_for :profile_sergio
      Nu::Score.new(oauth_user).daily_scores(Date.current)
    end
    it "contains the correct ingredient  amounts" do
      post "/v3/meals.json", {meal: {name: "Spaghetti Bolognese", components: [
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
                                                            ] }}, bearer_auth
      expect(json_body["meal"]["preview"]["nutrient_totals"]['protein']).to eq("56.281433")
      expect(json_body["meal"]["preview"]["nutrient_totals"]['carbs']).to eq("44.83044")
      expect(json_body["meal"]["preview"]["nutrient_totals"]['fibre']).to eq("12.720228")
    end
  end

  describe "delete" do
    let!(:meal) { FactoryGirl.create :meal, user: oauth_user }

    it "returns status 200" do
      delete "/v3/meals/#{meal.id}.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "allows a meal to be deleted" do
      expect {
        delete "/v3/meals/#{meal.id}.json", nil, bearer_auth
      }.to change(Meal, :count).by(-1)
    end
  end

  describe "update" do

    let(:meal) { FactoryGirl.create :meal, user: oauth_user }

    it "returns status 200" do
      put "/v3/meals/#{meal.id}.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}, {ingredient_id: pasta_corn_cooked.id, amount: 300}] }}, bearer_auth
      expect(response.status).to eq(200)
      expect(json_body["meal"]["name"]).to eq("Apple pie")
    end
    it "returns status 200 with application auth method" do
      put "/v3/meals/#{meal.id}.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}, {ingredient_id: pasta_corn_cooked.id, amount: 300}] }}, application_auth
      expect(response.status).to eq(200)
      expect(json_body["meal"]["name"]).to eq("Apple pie")
    end
    it "can change the name" do
      patch "/v3/meals/#{meal.id}.json", {meal: {name: "Chocolates", favourite: true, components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}] }}, bearer_auth
      expect(json_body["meal"]["name"]).to eq("Chocolates")
    end
    it "can change the type" do
      patch "/v3/meals/#{meal.id}.json", {meal: {name: "Chocolates", favourite: true, type: "dinner", components: [{ingredient_id: ingredient.id, amount: 70}, {ingredient_id: carrots_raw.id, amount: 200}] }}, bearer_auth
      expect(json_body["meal"]["type"]).to eq("dinner")
    end
    it "can accepts when no components are given" do
      patch "/v3/meals/#{meal.id}.json", {meal: {name: "Chocolates", favourite: true}}, bearer_auth
      expect(json_body["meal"]["name"]).to eq("Chocolates")
    end
  end

  describe "show" do

    let(:meal) { FactoryGirl.create :meal, user: oauth_user }

    it "returns status 200" do
      get "/v3/meals/#{meal.id}.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end
    it "returns status 200 with application auth method" do
      get "/v3/meals/#{meal.id}.json", nil, application_auth
      expect(response.status).to eq(200)
    end
    it "contains the meal" do
      get "/v3/meals/#{meal.id}.json", nil, bearer_auth
      expect(json_body["meal"]).to be_present
    end

  end

  describe "app request count" do
    it "shows the amount" do
      Sidekiq::Testing.inline! do
        post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
        post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
        post "/v3/meals.json", {meal: {name: "Apple pie", favourite: true, components: [{ingredient_id: ingredient.id, amount: 45}] }}, bearer_auth
        expect(oauth_application.stats.length).to eq(3)
      end
    end
  end

end
