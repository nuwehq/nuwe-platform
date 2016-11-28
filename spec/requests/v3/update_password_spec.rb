require 'rails_helper'

describe V3::ProfilesController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  describe "updating your password" do
    it "works" do
      patch "/v3/update_password.json", {user: {current_password: "railsisomakase", new_password: "newpassword"}}, bearer_auth
      expect(response.status).to eq(200)
    end
    it "doesn't work without the old password" do
      patch "/v3/update_password.json", {user: {new_password: "newpassword"}}, bearer_auth
      expect(response.status).to eq(400)
    end
    it "doesn't work with a wrong old password" do
      patch "/v3/update_password.json", {user: {current_password: "toteswrongpassword", new_password: "newpassword"}}, bearer_auth
      expect(response.status).to eq(400)
    end  
  end

end
