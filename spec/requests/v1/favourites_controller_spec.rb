require 'rails_helper'

describe V1::FavouritesController do

  include_context "signed up user"
  include_context "api token authentication"

  before do
    user.profile.update FactoryGirl.attributes_for :profile_female
  end
  
  describe "create" do
    let! (:meal) { FactoryGirl.create :meal, user: user }
    it "returns status 201" do
      post "/v1/meals/#{meal.id}/favourite.json", nil, token_auth
      expect(response.status).to eq(201)
    end
    it "favourited the correct meal" do
      post "/v1/meals/#{meal.id}/favourite.json", nil, token_auth
      expect(json_body["favourite"]["meal"]).to be_present
      expect(json_body["favourite"]["meal"]["id"]).to eq(meal.id)
    end
  end

  describe "create favourite product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201" do
      post "/v1/products/#{product.upc}/favourite.json", nil, token_auth
      expect(response.status).to eq(201)
    end
    it "favourited the correct product" do
      post "/v1/products/#{product.upc}/favourite.json", nil, token_auth
      expect(json_body["favourite"]["favouritable_type"]).to be_present
      expect(json_body["favourite"]["favouritable_type"]).to eq('Product')
    end
  end

  describe "destroy" do
    let! (:meal) { FactoryGirl.create :meal, user: user }
    before do
      FactoryGirl.create :favourite, favouritable: meal, user: user
    end
    it_behaves_like "a nice 404 response" do
      before do
        delete "/v1/meals/teamsnowden/favourite.json", nil, token_auth
      end
    end    
    it "returns status 200" do
      delete "/v1/meals/#{meal.id}/favourite.json", nil, token_auth
      expect(response.status).to eq(200)
    end
    it "deletes the correct favourite" do
      expect {
        delete "/v1/meals/#{meal.id}/favourite.json", nil, token_auth
        }.to change(Favourite, :count).by(-1)
    end
  end

  describe "destroy" do
    let! (:product) { FactoryGirl.create :product }
    before do
      FactoryGirl.create :favourite, favouritable: product, user: user
    end
    it_behaves_like "a nice 404 response" do
      before do
        delete "/v1/meals/teamsnowden/favourite.json", nil, token_auth
      end
    end    
    it "returns status 200" do
      delete "/v1/products/#{product.upc}/favourite.json", nil, token_auth
      expect(response.status).to eq(200)
    end
    it "deletes the correct favourite" do
      expect {
        delete "/v1/products/#{product.upc}/favourite.json", nil, token_auth
        }.to change(Favourite, :count).by(-1)
    end
  end


  describe "index" do
    let! (:meal) { FactoryGirl.create :meal, user: user }
    let! (:product) { FactoryGirl.create :product }
    before do
      FactoryGirl.create :favourite, favouritable: meal, user: user
      FactoryGirl.create :favourite, favouritable: product, user: user
    end
    it "shows all my favourited meals" do
      get "/v1/favourites.json", nil, token_auth
      expect(response.status).to eq(200)
    end
    it "shows the meals for the correct user" do
      get "/v1/favourites.json", nil, token_auth
      expect(Favourite.last.user_id).to eq(user.id)
    end
    it "is a paginated list" do
      get "/v1/favourites.json?per_page=1", nil, token_auth
      expect(json_body["favourites"].length).to eq(1)
    end
  end

end
