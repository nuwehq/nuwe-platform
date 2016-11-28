require 'rails_helper'

describe Admin::UsersController do

  describe "index" do

    include_context "signed up admin"
    include_context "api token authentication"

    let!(:other) { FactoryGirl.create :user }

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/admin/users.json"
      end
    end

    it "contains a list of users" do
      get "/v1/admin/users.json", {}, token_auth
      expect(response).to be_success
      expect(json_body["users"].first["id"]).to eq(other.id)
    end
  end

  describe "show" do

    include_context "signed up admin"
    include_context "api token authentication"

    let(:other) { FactoryGirl.create :user }

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/admin/users/#{other.id}.json"
      end
    end

    it "contains the user" do
      get "/v1/admin/users/#{other.id}.json", {}, token_auth
      expect(response).to be_success
      expect(json_body["user"]["id"]).to eq(other.id)
    end
  end

end
