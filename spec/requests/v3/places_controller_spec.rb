require 'rails_helper'

describe V3::PlacesController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:factual_places_service) { FactoryGirl.create :factual_places_service}
  let! (:nuwe_places_service) { FactoryGirl.create :nuwe_places_service}
  let! (:nuwe_meals_service) { FactoryGirl.create :nuwe_meals_service}

  before do
    FactoryGirl.create :capability, service_id: factual_places_service.id, application_id: oauth_application.id
    FactoryGirl.create :capability, service_id: nuwe_places_service.id, application_id: oauth_application.id
    FactoryGirl.create :capability, service_id: nuwe_meals_service.id, application_id: oauth_application.id
  end
  
  describe "index" do
    it "returns status 200" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, bearer_auth
      end
      expect(response.status).to eq(200)
    end
    it "returns status 200 when using application auth method" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, application_auth
      end
      expect(response.status).to eq(200)
    end
    it "returns places' info" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, bearer_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to be_present
    end
    it "should work without radius" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?lat=34.06018&lon=-118.41835", nil, bearer_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to be_present
    end
    it "only returns whitelisted categories" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?lat=34.06018&lon=-118.41835&radius=5000", nil, bearer_auth
      end
      body = JSON.parse(response.body)
      expect(body["places"]).to_not be_empty
    end
    it "should not work without lat&long" do
      VCR.use_cassette 'factualapi-places' do
        get "/v3/places.json?", nil, bearer_auth
      end
      body = JSON.parse(response.body)
      expect(response.status).to eq(400)
    end
  end

  describe "create for meal" do
    let! (:meal) { FactoryGirl.create :meal, user: oauth_user }
    it "returns status 201 and add place to meal" do
      post "/v3/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, bearer_auth
      expect(meal.places).to be_present
      expect(response.status).to eq(201)
    end
    it "returns status 201 when using the application auth method" do
      post "/v3/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, application_auth
      expect(meal.places).to be_present
      expect(response.status).to eq(201)
    end
    it "allows several places to be added at the same time" do
      post "/v3/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      expect(meal.places).to be_present
      expect(response.status).to eq(201)
    end
  end

  describe "create for product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201 and adds place to product" do
      post "/v3/products/#{product.upc}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, bearer_auth
      expect(product.places).to be_present
      expect(response.status).to eq(201)
    end
    it "returns status 201 when using the application auth method" do
      post "/v3/products/#{product.upc}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}]}, application_auth
      expect(product.places).to be_present
      expect(response.status).to eq(201)
    end
    it "allows several places to be added at the same time" do
      post "/v3/products/#{product.upc}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      expect(product.places).to be_present
      expect(response.status).to eq(201)
    end
  end

  describe "update for meal" do
    let! (:meal) { FactoryGirl.create :meal, user: oauth_user }
    it "returns status 201" do
      patch "/v3/meals/#{meal.id}/places.json", {places: [{name: "Boulangerie", address: "13 Bread Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      expect(response.status).to eq(201)
    end
    it "returns status 201 when using the application auth method" do
      patch "/v3/meals/#{meal.id}/places.json", {places: [{name: "Boulangerie", address: "13 Bread Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, application_auth
      expect(response.status).to eq(201)
    end
    it "can update place details" do
      expect {
        patch "/v3/meals/#{meal.id}/places.json", {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      }.to change(Place, :count).by(2)
    end
    it "can remove all the places" do
      expect {
        patch "/v3/meals/#{meal.id}/places.json", {places: []}, bearer_auth
      }.to change(Place, :count).by(0)
    end
    it "can ignore the update if there is no places param" do
      post "/v3/meals/#{meal.id}/places.json", {places: [{name: "Iceland Foods ltd", address: "26 Salisbury St Blandford Forum, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      patch "/v3/meals/#{meal.id}/places.json", {}, bearer_auth
      expect(json_body["meal"]["places"]).not_to be_empty
    end
  end


  describe "update for product" do
    let! (:product) { FactoryGirl.create :product }
    it "returns status 201" do
      patch "/v3/products/#{product.upc}/places.json", {places: [{name: "Boulangerie", address: "13 Bread Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      expect(response.status).to eq(201)
    end
    it "can update place details" do
      expect {
        patch "/v3/products/#{product.upc}/places.json", {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }, bearer_auth
      }.to change(Place, :count).by(2)
    end
    it "can remove all the places" do
      expect {
        patch "/v3/products/#{product.upc}/places.json", {places: []}, bearer_auth
      }.to change(Place, :count).by(0)
    end
  end

  describe "update product without places params" do
    let! (:product_with_place) { FactoryGirl.create :product_with_place }
    it "can ignore the update" do
      patch "/v3/products/#{product_with_place.upc}/places.json", {}, bearer_auth
      expect(json_body["product"]["places"]).not_to be_empty
    end
  end

end
