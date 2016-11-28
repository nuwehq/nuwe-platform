require 'rails_helper'

describe "making a request to an unrecognised path" do
  it "returns 404" do
    get "/v1/nowhere"
    expect(response.status).to eq(404)
    expect(json_body["error"]).to be_present
  end
end
