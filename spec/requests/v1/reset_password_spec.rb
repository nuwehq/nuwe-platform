require 'rails_helper'

describe V1::ResetPasswordsController do

  include_context "throttle"

  let(:user) { FactoryGirl.create :user }

  it_behaves_like "a nice 404 response" do
    before do
      post "/v1/reset_password.json", {user: {email: "lkjbhvgftugy@bla.com"}}
    end
  end

  describe "resetting password" do
    it "sends a mail to the user" do
      Sidekiq::Testing.inline! do
        post "/v1/reset_password.json", {user: {email: user.email}}
      end
      expect(ActionMailer::Base.deliveries.last.subject).to include("password reset")
    end
  end

end
