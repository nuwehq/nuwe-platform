require 'rails_helper'

describe V1::StatusController do
  before do
    FactoryGirl.create :gorby
  end

  it "returns ok response" do
    get "/v1/go-go-gorby-status"
    expect(response.status).to eq(200)
  end
end
