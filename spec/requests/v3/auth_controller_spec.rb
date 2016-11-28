require 'rails_helper'

describe V3::AuthController do

  include_context "throttle"

  context "v1 user" do

    let!(:user) { FactoryGirl.create :v1_user }

    describe "correct password" do

      it "lets a DEV access the bearer token" do
        post "/oauth/token", {
          email: user.email,
          password: user.password,
          grant_type: "password"
        }
        expect(json_body["access_token"]).to be_present
      end

      it "doesn't work with a wrong password" do
        post "/oauth/token", {
          email: user.email,
          password: "toteswrongpassword",
          grant_type: "password"
        }
        expect(json_body["error"]).to be_present
      end


      it "has status 200" do
        post "/v3/auth.json", {session: {email: user.email, password: "letmeinplease"}}
        expect(response.status).to eq(200)
      end

      it "contains the user" do
        post "/v3/auth.json", {session: {email: user.email, password: "letmeinplease"}}
        expect(json_body["user"]).to be_present
      end
    end

    describe "incorrect password" do
      it "has status 401" do
        post "/v3/auth.json", {session: {email: user.email, password: "incorrect"}}
        expect(response.status).to eq(401)
      end

      it "has an error message" do
        post "/v3/auth.json", {session: {email: user.email, password: "incorrect"}}
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    describe "missing password" do
      it "has status 400" do
        post "/v3/auth.json", {session: {email: user.email}}
        expect(response.status).to eq(400)
      end

      it "has an error message" do
        post "/v3/auth.json", {session: {email: user.email}}
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end
  end

  context "v2 user" do

    let!(:user) { FactoryGirl.create :v2_user }

    describe "correct password" do
      it "has status 200" do
        post "/v3/auth.json", {session: {email: user.email, password: "letmeinplease"}}
        expect(response.status).to eq(200)
      end

      it "contains the user" do
        post "/v3/auth.json", {session: {email: user.email, password: "letmeinplease"}}
        expect(json_body["user"]).to be_present
      end

      it "is case-insensitive" do
        post "/v3/auth.json", {session: {email: user.email.upcase, password: "letmeinplease"}}
        expect(response.status).to eq(200)
      end
    end

    describe "incorrect password" do
      it "has status 401" do
        post "/v3/auth.json", {session: {email: user.email, password: "incorrect"}}
        expect(response.status).to eq(401)
      end

      it "has an error message" do
        post "/v3/auth.json", {session: {email: user.email, password: "incorrect"}}
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    describe "missing password" do
      it "has status 400" do
        post "/v3/auth.json", {session: {email: user.email}}
        expect(response.status).to eq(400)
      end

      it "has an error message" do
        post "/v3/auth.json", {session: {email: user.email}}
        expect(json_body["error"]["message"]).to_not be_nil
      end
    end
  end

  context "login attempts" do

    it "allows 5 per minute maximum" do
      6.times do
        post "/v3/auth.json", {session: {email: "unknown@example.com", password: "haxxor"}}
      end
      expect(response.status).to eq(429)
    end

    it "locks the account after 100 attempts"

  end

  context "unknown user" do
    it "has status 404" do
      post "/v3/auth.json", {session: {email: "unknown@example.com", password: "haxxor"}}
      expect(response.status).to eq(404)
    end

    it "has an error message" do
      post "/v3/auth.json", {session: {email: "unknown@example.com", password: "haxxor"}}
      expect(json_body["error"]["message"]).to_not be_nil
    end
  end


end
