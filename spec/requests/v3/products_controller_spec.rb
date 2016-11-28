require 'rails_helper'

describe V3::ProductsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:factual_upc_service) { FactoryGirl.create :factual_upc_service}
  let! (:nuwe_meals_service) { FactoryGirl.create :nuwe_meals_service}

  before do
    oauth_user.profile.update FactoryGirl.attributes_for :profile_giulia
    Nu::Score.new(oauth_user).daily_scores(Date.current)
    FactoryGirl.create :capability, service_id: nuwe_meals_service.id, application_id: oauth_application.id
  end

  describe "show" do

    context "Factual Key and Secret are missing" do
      before do
        FactoryGirl.create :capability, service_id: factual_upc_service.id, application_id: oauth_application.id
      end
      let!(:product) { FactoryGirl.create :product }

      it "gives the correct error message when remote credentials are missing" do
        get "/v3/products/#{product.upc}.json", nil, bearer_auth
        expect(response.body).to include("Remote application key is required")
      end
    end

    context "product already present" do
      before do
        FactoryGirl.create :capability, service_id: factual_upc_service.id, application_id: oauth_application.id, remote_application_key: "0123456789", remote_application_secret: "0987654321"
      end
      let!(:product) { FactoryGirl.create :product }

      it "returns ok status" do
        get "/v3/products/#{product.upc}.json", nil, bearer_auth
        expect(response.status).to eq(200)
      end

      it "returns ok status when using the application auth method" do
        get "/v3/products/#{product.upc}.json", nil, application_auth
        expect(response.status).to eq(200)
      end

      it "contains the product info" do
        get "/v3/products/#{product.upc}.json", nil, bearer_auth
        expect(json_body["product"]["name"]).to eq(product.name)
      end

      it "contains the product preview" do
        get "/v3/products/#{product.upc}.json", nil, bearer_auth
        expect(json_body["product"]["preview"]["predicted_nutrient_totals"]["kcal"]).to eq("200.0")
      end
    end

    context "if edible product does not exist in in-house db" do
      before do
        FactoryGirl.create :capability, service_id: factual_upc_service.id, application_id: oauth_application.id, remote_application_key: "0123456789", remote_application_secret: "0987654321"
      end
      it "create a new product in db" do
        expect {
          VCR.use_cassette 'factualapi' do
            get "/v3/products/048500010976.json", nil, bearer_auth
          end
        }.to change(Product, :count).by(1)
      end

      it "creates images" do
        expect {
          VCR.use_cassette 'factualapi' do
            get "/v3/products/048500010976.json", nil, bearer_auth
          end
        }.to change(Image, :count).by(3)
      end

      it "creates nutritional properties" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        expect(json_body["product"]["serving_size"]).to eq('8 oz')
        expect(json_body["product"]["kcal"]).to eq('130.0')
        expect(json_body["product"]["protein"]).to eq('0.0')
      end

      it "creates factual ingredients" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        expect(json_body["product"]["ingredient_names"]).to include("Filtered Water")
        expect(json_body["product"]["ingredient_names"].count).to eq(8)
      end

      it "creates raw nutritional properties" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        expect(json_body["product"]["raw_nutritional_data"]).to include("total_fat")
        expect(json_body["product"]["raw_nutritional_data"]).to include("calcium")
        expect(json_body["product"]["raw_nutritional_data"].count).to eq(23)
      end

      it "can update properties" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        patch "/v3/products/048500010976.json", {product: {type: "breakfast", lat: 50.8571601, lon: -2.9999999 }}, bearer_auth
        expect(json_body["product"]["lat"]).to eq('50.8571601')
      end

      it "can update properties with the application auth method" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, application_auth
        end
        patch "/v3/products/048500010976.json", {product: {type: "breakfast", lat: 50.8571601, lon: -2.9999999 }}, application_auth
        expect(json_body["product"]["lat"]).to eq('50.8571601')
      end

      it "can favourite a product" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        patch "/v3/products/048500010976.json", {product: {favourite: true }}, bearer_auth
        expect(json_body["product"]["favourite"]).to eq(true)
      end

      it "can add several places" do
        VCR.use_cassette 'factualapi' do
          get "/v3/products/048500010976.json", nil, bearer_auth
        end
        patch "/v3/products/048500010976.json", {product: {places: [{name: "Pizza place", address: "14 Pepperoni Street, Dorset DT11 7AT United Kingdom", lat: 50.8571601, lon: -2.1645891}, {name: "Second place", address: "Somewhere in the United Kingdom", lat: 50.8571601, lon: -2.1645891}] }}, bearer_auth
        expect(json_body["product"]["places"]).to_not be_empty
      end

      it "gives the correct error code" do
        VCR.use_cassette 'factualerror' do
          get "/v3/products/031407010976.json", nil, bearer_auth
        end
        expect(response.status).to eq(404)
      end
    end

    context "if inedible product does not exist in in-house db" do
      before do
        FactoryGirl.create :capability, service_id: factual_upc_service.id, application_id: oauth_application.id, remote_application_key: "0123456789", remote_application_secret: "0987654321"
      end

      it "creates a new product in the db" do
        expect {
          VCR.use_cassette 'factualnonfood' do
            get "/v3/products/097012548842.json", nil, bearer_auth
          end
        }.to change(Product, :count).by(1)
      end

      it "creates product properties" do
        VCR.use_cassette 'factualnonfood' do
          get "/v3/products/097012548842.json", nil, bearer_auth
        end
        expect(json_body["product"]["brand"]).to eq("LOreal")
        expect(json_body["product"]["name"]).to eq('Nutritive Bain Oleo-Curl Curl Definition Shampoo')
        expect(json_body["product"]["upc"]).to eq('097012548842')
      end

      it "saves the product as an inedible product" do
        VCR.use_cassette 'factualnonfood' do
          get "/v3/products/097012548842.json", nil, bearer_auth
        end
        expect(Product.last.eat_ready).to eq(false)
      end
    end
  end

  describe "search" do

    context "no product name params entered" do

      it "gives the correct error message if params[:name] is empty" do
        get "/v3/products/search.json", nil, bearer_auth
        expect(response.status).to eq(400)
      end
    end

    context "searches factual db by name keyword" do
      it "returns ok status" do
        VCR.use_cassette 'factualsearch' do
          get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
        end
          expect(response.status).to eq(200)
      end

      it "returns ok status when using the application auth method" do
        VCR.use_cassette 'factualsearch' do
          get "/v3/products/search.json?name=cheese%20dip%20original", nil, application_auth
        end
        expect(response.status).to eq(200)
      end

      it "contains the expected number of products" do
        VCR.use_cassette 'factualsearch' do
          get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
        end
        expect(json_body["products"].length).to eq(9)
      end

      it "contains the products' info with key values that match the local db" do
        VCR.use_cassette 'factualsearch' do
          get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
        end
        expect(json_body["products"].first.keys).to include("name")
        expect(json_body["products"].first.values).to include("Dressing & Dip Original Bleu Cheese")
        expect(json_body["products"].second.keys).to include("name")
        expect(json_body["products"].second.values).to include("Cheese Dip Original")
        expect(json_body["products"].third.keys).to include("name")
        expect(json_body["products"].third.values).to include("Cheese Dip Original")
        expect(json_body["products"].fourth.keys).to include("name")
        expect(json_body["products"].fourth.values).to include("Farmhouse Original Savory Bleu Cheese Dressing & Dip")
        expect(json_body["products"].fifth.keys).to include("name")
        expect(json_body["products"].fifth.values).to include("Dressing & Dip Original Bleu Cheese")
        expect(json_body["products"].last.keys).to include("name")
        expect(json_body["products"].last.values).to include("Cheese Dip Original With Tomatoes & Peppers")
      end

      it "adds products to local db if they do not already exist" do
        expect {
          VCR.use_cassette 'factualsearch-create' do
            get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
          end
        }.to change(Product, :count).by(9)
      end

      it "adds all products as food with nutritional values" do
        VCR.use_cassette 'factualsearch-create' do
          get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
        end
        Product.all.each do |product|
          expect(product.eat_ready).to eq(true)
          expect(product.kcal).not_to eq(0)
        end
      end

      it "creates images" do
        expect {
          VCR.use_cassette 'factualsearch-create' do
            get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
          end
        }.to change(Image, :count).by(8)
      end

      it "does not add products to local db if they do already exist" do
        cheese_dip = FactoryGirl.create :cheese_dip
        expect {
          VCR.use_cassette 'factualsearch-create' do
            get "/v3/products/search.json?name=cheese%20dip%20original", nil, bearer_auth
          end
        }.to change(Product, :count).by(8)
      end

      it "returns a max of 20 results" do
        expect {
          VCR.use_cassette 'factualsearch-max' do
            get "/v3/products/search.json?name=tofu", nil, bearer_auth
          end
        }.to change(Product, :count).by(20)
        expect(json_body["products"].length).to eq(20)
      end

      it "returns results based on page requested" do
        expect {
          VCR.use_cassette 'factualsearch-page2' do
            get "/v3/products/search.json?name=tofu&page=2", nil, bearer_auth
          end
        }.to change(Product, :count).by(20)
        expect(json_body["products"].first.values).to include("Tofu Organic Firm")
        expect(json_body["products"].last.values).to include("Tofu Silken Chocolate")
      end

      it "gives the correct error message if params[:page] is greater than 5" do
        get "/v3/products/search.json?name=tofu&page=6", nil, bearer_auth
        expect(response.status).to eq(400)
      end
    end
  end
end
