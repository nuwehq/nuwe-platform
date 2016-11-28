require 'rails_helper'

describe ConnectParse do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let!(:parse_app) { FactoryGirl.create :parse_app, port: 80, application_id: oauth_application.id }

  context "without correct keys" do
    it "responds with an error message" do
      VCR.use_cassette 'parse-connector' do
        response = ConnectParse.new(oauth_application, nil).schemas
        expect(response.body["error"]).to be_present
      end
    end
  end
end
