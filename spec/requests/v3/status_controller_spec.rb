require 'rails_helper'

describe V3::StatusController do
  before do
    FactoryGirl.create :oauth_token
  end

  it "returns ok response" do
    get "/v3/go-go-gorby-status"
    expect(response.status).to eq(200)
  end
end



