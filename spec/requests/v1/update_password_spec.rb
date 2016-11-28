require 'rails_helper'

describe V1::ProfilesController do

  include_context "signed up user"
  include_context "api token authentication"

  describe "updating your password" do
    it "works" do
      patch "/v1/update_password.json", {user: {current_password: "railsisomakase", new_password: "newpassword"}}, token_auth
      expect(response.status).to eq(200)
    end
    it "doesn't work without the old password" do
      patch "/v1/update_password.json", {user: {new_password: "newpassword"}}, token_auth
      expect(response.status).to eq(400)
    end
    it "doesn't work with a wrong old password" do
      patch "/v1/update_password.json", {user: {current_password: "toteswrongpassword", new_password: "newpassword"}}, token_auth
      expect(response.status).to eq(400)
    end  
  end

end
