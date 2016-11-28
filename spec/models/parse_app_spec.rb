require 'rails_helper'

RSpec.describe ParseApp, :type => :model do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let(:parse_app) { FactoryGirl.create :parse_app, application_id: oauth_application.id }

  describe "when created" do
    it "belongs to an application" do
      expect(parse_app.application_id).to eq(oauth_application.id)
      ParseServiceWorker.perform_async(oauth_application)
    end

    it "has a randomly created app_id" do
      expect(parse_app.app_id).to_not be(nil)
    end
  end

end
