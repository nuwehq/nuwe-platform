require 'rails_helper'

describe V3::UsersController do

  include_context "signed up developer"
  include_context "bearer token authentication"

  describe "create" do

    let(:user) { User.find_by_email! "me@example.com" }

    context "valid request" do
      it "has status 'created'" do
        create_user_request
        expect(response.status).to eq(201)
      end

      it "creates users" do
        expect do
          create_user_request
          create_user_request email: "metoo@example.com"
        end.to change(User, :count).by(2)
      end

      it "contains the user" do
        create_user_request
        expect(json_body["user"]).to_not be_nil
      end

      # These keys must be present, value might be nil
      %w(bmi height weight).each do |attribute|
        it "contains #{attribute} key" do
          create_user_request
          expect(json_body["user"]).to include(attribute)
        end
      end

      it "contains tokens" do
        create_user_request
        expect(json_body["user"]["tokens"]).to_not be_nil
      end

      it "contains nutritional information" do
        create_user_request
        expect(json_body["user"]["nutrition"]).to include("error")
      end
    end

    context "facebook login" do
      it "stores the facebook_id" do
        create_user_request facebook_id: "998216378153821"
        expect(User.find_by(email: "me@example.com").facebook_id).to eq("998216378153821")
      end

      it "reports duplicate facebook ids" do
        create_user_request facebook_id: "998216378153821"
        create_user_request facebook_id: "998216378153821"
        expect(response.status).to eq(400)
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    context "missing email" do
      it "reports an error" do
        post "/v3/users.json", {user: {email: "me@example.com"}}
        expect(response.status).to eq(400)

        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    context "missing password" do
      it "reports an error" do
        post "/v3/users.json", {user: {password: "supersecret"}}
        expect(response.status).to eq(400)

        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    context "existing user" do
      let!(:user) { FactoryGirl.create(:user) }

      it "reports an error" do
        post "/v3/users.json", {user: {email: user.email, password: "supersecret"}}
        expect(response.status).to eq(400)
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    context "creates bearer token with correct application credentials" do
      let(:user) { User.find_by_email! "new_user@example.com" }

      it "creates a bearer token for authorized application" do
        expect {
          VCR.use_cassette "users/create_with_authorized_application" do
            post "/v3/users.json", {user: {email: "new_user@example.com", password: "supersecret"}}, application_auth
          end
        }.to change(Doorkeeper::AccessToken, :count).by(1)
      end

      it "returns an error if incorrect application credentials" do
        VCR.use_cassette "users/create_with_authorized_application" do
          post "/v3/users.json", {user: {email: "new_user@example.com", password: "supersecret"}}, invalid_app_auth
        end
        expect(response.status).to eq(401)
      end

      it "does not create a user if incorrect application credentials" do
        expect {
          VCR.use_cassette "users/create_with_authorized_application" do
            post "/v3/users.json", {user: {email: "new_user@example.com", password: "supersecret"}}, invalid_app_auth
          end
        }.to change(User, :count).by(0)
      end
    end
  end
end
