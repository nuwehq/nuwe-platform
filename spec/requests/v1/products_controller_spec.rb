require 'rails_helper'

describe V1::ProductsController do

  include_context "signed up user"
  include_context "api token authentication"

  before do
    user.profile.update FactoryGirl.attributes_for :profile_giulia
    Nu::Score.new(user).daily_scores(Date.current)
  end

  describe "show" do

    context "product already present" do
      let!(:product) { FactoryGirl.create :product }

      it "returns ok status" do
        get "/v1/products/#{product.upc}.json", nil, token_auth
        expect(response.status).to eq(200)
      end

      it "contains the product info" do
        get "/v1/products/#{product.upc}.json", nil, token_auth
        expect(json_body["product"]["name"]).to eq(product.name)
      end

      it "contains the product preview" do
        get "/v1/products/#{product.upc}.json", nil, token_auth
        expect(json_body["product"]["preview"]["predicted_nutrient_totals"]["kcal"]).to eq("200.0")
      end
    end

    context "if edible product does not exist in in-house db" do
      it "create a new product in db" do
        expect {
          VCR.use_cassette 'factualapi' do
            get "/v1/products/048500010976.json", nil, token_auth
          end
        }.to change(Product, :count).by(1)
      end

      it "creates images" do
        expect {
          VCR.use_cassette 'factualapi' do
            get "/v1/products/048500010976.json", nil, token_auth
          end
        }.to change(Image, :count).by(3)
      end

      it "creates nutritional properties" do
        VCR.use_cassette 'factualapi' do
          get "/v1/products/048500010976.json", nil, token_auth
        end
        expect(json_body["product"]["serving_size"]).to eq('8 oz')
        expect(json_body["product"]["kcal"]).to eq('130.0')
        expect(json_body["product"]["protein"]).to eq('0.0')
      end

      it "can update properties" do
        VCR.use_cassette 'factualapi' do
          get "/v1/products/048500010976.json", nil, token_auth
        end
        patch "/v1/products/048500010976.json", {product: {type: "breakfast", lat: 50.8571601, lon: -2.9999999 }}, token_auth
        expect(json_body["product"]["lat"]).to eq('50.8571601')
      end

      it "can favourite a product" do
        VCR.use_cassette 'factualapi' do
          get "/v1/products/048500010976.json", nil, token_auth
        end
        patch "/v1/products/048500010976.json", {product: {favourite: true }}, token_auth
        expect(json_body["product"]["favourite"]).to eq(true)
      end

      it "can add several places" do
        VCR.use_cassette 'factualapi' do
          get "/v1/products/048500010976.json", nil, token_auth
        end
        patch "/v1/products/048500010976.json", {product: {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }}, token_auth
        expect(json_body["product"]["places"]).to_not be_empty
      end

      it "gives the correct error code" do
        VCR.use_cassette 'factualerror' do
          get "/v1/products/031407010976.json", nil, token_auth
        end
        expect(response.status).to eq(404)
      end
    end

    context "if inedible product does not exist in in-house db" do
      it "creates a new product in the db" do
        expect {
          VCR.use_cassette 'factualnonfood' do
            get "/v1/products/097012548842.json", nil, token_auth
          end
        }.to change(Product, :count).by(1)
      end

      it "creates product properties" do
        VCR.use_cassette 'factualnonfood' do
          get "/v1/products/097012548842.json", nil, token_auth
        end
        expect(json_body["product"]["brand"]).to eq("LOreal")
        expect(json_body["product"]["name"]).to eq('Nutritive Bain Oleo-Curl Curl Definition Shampoo')
        expect(json_body["product"]["upc"]).to eq('097012548842')
      end
    end
  end
end
