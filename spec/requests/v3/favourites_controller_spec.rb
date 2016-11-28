require 'rails_helper'

describe V3::FavouritesController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:nuwe_meals_service) { FactoryGirl.create :nuwe_meals_service}

  before do
    oauth_user.profile.update FactoryGirl.attributes_for :profile_female
    FactoryGirl.create :capability, service_id: nuwe_meals_service.id, application_id: oauth_application.id
  end

  describe "create" do
    let! (:meal) { FactoryGirl.create :meal, user: oauth_user }
    it "returns status 201" do
      post "/v3/meals/#{meal.id}/favourite.json", nil, bearer_auth
      expect(response.status).to eq(201)
    end
    it "favourited the correct meal" do
      post "/v3/meals/#{meal.id}/favourite.json", nil, bearer_auth
      expect(json_body["favourite"]["meal"]).to be_present
      expect(json_body["favourite"]["meal"]["id"]).to eq(meal.id)
    end
  end

  describe "create favourite product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201" do
      post "/v3/products/#{product.upc}/favourite.json", nil, bearer_auth
      expect(response.status).to eq(201)
    end
    it "favourited the correct product" do
      post "/v3/products/#{product.upc}/favourite.json", nil, bearer_auth
      expect(json_body["favourite"]["favouritable_type"]).to be_present
      expect(json_body["favourite"]["favouritable_type"]).to eq('Product')
    end
  end

  describe "destroy" do
    let! (:meal) { FactoryGirl.create :meal, user: oauth_user }
    before do
      FactoryGirl.create :favourite, favouritable: meal, user: oauth_user
    end
    it_behaves_like "a nice 404 response" do
      before do
        delete "/v3/meals/teamsnowden/favourite.json", nil, bearer_auth
      end
    end
    it "returns status 200" do
      delete "/v3/meals/#{meal.id}/favourite.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end
    it "deletes the correct favourite" do
      expect {
        delete "/v3/meals/#{meal.id}/favourite.json", nil, bearer_auth
        }.to change(Favourite, :count).by(-1)
    end
  end

  describe "destroy" do
    let! (:product) { FactoryGirl.create :product }
    before do
      FactoryGirl.create :favourite, favouritable: product, user: oauth_user
    end
    it_behaves_like "a nice 404 response" do
      before do
        delete "/v3/meals/teamsnowden/favourite.json", nil, bearer_auth
      end
    end
    it "returns status 200" do
      delete "/v3/products/#{product.upc}/favourite.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end
    it "deletes the correct favourite" do
      expect {
        delete "/v3/products/#{product.upc}/favourite.json", nil, bearer_auth
        }.to change(Favourite, :count).by(-1)
    end
  end


  describe "index" do
    let! (:meal) { FactoryGirl.create :meal, user: oauth_user }
    let! (:product) { FactoryGirl.create :product }
    before do
      FactoryGirl.create :favourite, favouritable: meal, user: oauth_user
      FactoryGirl.create :favourite, favouritable: product, user: oauth_user
    end
    it "shows all my favourited meals" do
      get "/v3/favourites.json", nil, bearer_auth
      expect(response.status).to eq(200)
    end
    it "shows the meals for the correct user" do
      get "/v3/favourites.json", nil, bearer_auth
      expect(Favourite.last.user_id).to eq(oauth_user.id)
    end
    it "is a paginated list" do
      get "/v3/favourites.json?per_page=1", nil, bearer_auth
      expect(json_body["favourites"].length).to eq(1)
    end
  end

end
