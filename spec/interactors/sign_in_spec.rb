require 'rails_helper'

describe SignIn do

  it_behaves_like "failure on missing email"
  it_behaves_like "failure on missing password"

  describe "authenticate a v1 user" do

    let!(:user) { FactoryGirl.create :v1_user }

    it "works" do
      result = SignIn.call({email: user.email, password: "letmeinplease"})
      expect(result).to be_success
    end

    it "fails when password is invalid" do
      result = SignIn.call({email: user.email, password: "haxor"})
      expect(result).to be_failure
    end

    it "writes the v2 password" do
      result = SignIn.call({email: user.email, password: "letmeinplease"})
      expect(user.reload.password_digest).to be_present
    end

    it "removes the md5 password" do
      result = SignIn.call({email: user.email, password: "letmeinplease"})
      expect(user.reload.md5_password).to be_nil
    end

  end

  describe "authenticate a v2 user" do

    let!(:user) { FactoryGirl.create :v2_user }

    it "works" do
      result = SignIn.call({email: user.email, password: "letmeinplease"})
      expect(result).to be_success
    end

    it "fails when password is invalid" do
      result = SignIn.call({email: user.email, password: "haxor"})
      expect(result).to be_failure
    end

  end

end
