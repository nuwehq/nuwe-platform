require 'rails_helper'

describe V1::PlacesController do
  include_context "signed up user"
  include_context "api token authentication"
  
  describe "index" do
    it "returns status 200" do
      VCR.use_cassette 'factualapi-places' do
        get "/v1/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, token_auth
      end
      expect(response.status).to eq(200)
    end
    it "returns places' info" do
      VCR.use_cassette 'factualapi-places' do
        get "/v1/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, token_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to be_present
    end
    it "should work without radius" do
      VCR.use_cassette 'factualapi-places' do
        get "/v1/places.json?lat=34.06018&lon=-118.41835", nil, token_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to be_present
    end
    it "only returns whitelisted categories" do
      VCR.use_cassette 'factualapi-places' do
        get "/v1/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, token_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to_not be_empty
    end
    it "should not work without lat&long" do
      VCR.use_cassette 'factualapi-places' do
        get "/v1/places.json?", nil, token_auth
      end
      body = JSON.parse(response.body)
      expect(response.status).to eq(400)
    end
  end
  
  describe "create for meal" do
    let! (:meal) { FactoryGirl.create :meal, user: user }
    it "returns status 201 and add place to meal" do
      post "/v1/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, token_auth
      expect(meal.places).to be_present
      expect(response.status).to eq(201)
    end
    it "allows several places to be added at the same time" do
      post "/v1/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      expect(meal.places).to be_present
      expect(response.status).to eq(201)
    end
  end

  describe "create for product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201 and adds place to product" do
      post "/v1/products/#{product.upc}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, token_auth
      expect(product.places).to be_present
      expect(response.status).to eq(201)
    end
    it "allows several places to be added at the same time" do
      post "/v1/products/#{product.upc}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      expect(product.places).to be_present
      expect(response.status).to eq(201)
    end
  end

  describe "update for meal" do
    let! (:meal) { FactoryGirl.create :meal, user: user }
    it "returns status 201" do
      patch "/v1/meals/#{meal.id}/places.json", {places: [{name: "Boulangerie", address: "13 Bread Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      expect(response.status).to eq(201)
    end
    it "can update place details" do
      expect {
        patch "/v1/meals/#{meal.id}/places.json", {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      }.to change(Place, :count).by(2)
    end
    it "can remove all the places" do
      expect {
        patch "/v1/meals/#{meal.id}/places.json", {places: []}, token_auth
      }.to change(Place, :count).by(0)
    end
    it "can ignore the update if there is no places param" do
      post "/v1/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      patch "/v1/meals/#{meal.id}/places.json", {}, token_auth
      expect(json_body["meal"]["places"]).not_to be_empty 
    end
  end


  describe "update for product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201" do
      patch "/v1/products/#{product.upc}/places.json", {places: [{name: "Boulangerie", address: "13 Bread Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      expect(response.status).to eq(201)
    end
    it "can update place details" do
      expect {
        patch "/v1/products/#{product.upc}/places.json", {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, token_auth
      }.to change(Place, :count).by(2)
    end
    it "can remove all the places" do
      expect {
        patch "/v1/products/#{product.upc}/places.json", {places: []}, token_auth
      }.to change(Place, :count).by(0)
    end
  end

  describe "update product without places params" do
    let! (:product_with_place) { FactoryGirl.create :product_with_place }
    it "can ignore the update" do
      patch "/v1/products/#{product_with_place.upc}/places.json", {}, token_auth
      expect(json_body["product"]["places"]).not_to be_empty 
    end
  end
  
end
