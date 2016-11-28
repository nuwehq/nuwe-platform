shared_examples "failure on missing email" do

  it "fails when email is missing" do
    result = described_class.call({password: "letmeinplease"})
    expect(result).to be_failure
  end

end

shared_examples "failure on missing password" do

  it "fails when password is missing" do
    result = described_class.call({email: "me@example.com"})
    expect(result).to be_failure
  end

end

shared_examples "an authenticated resource" do

  it "has status 401" do
    expect(response.status).to eq(401)
  end

  it "shows the error" do
    expect(json_body["error"]["message"]).to be_present
  end

end

shared_examples "an authenticated V3 resource" do

  it "has status 401" do
    expect(response.status).to eq(401)
  end

end

shared_examples "a nice 404 response" do

  it "has status 404" do
    expect(response.status).to eq(404)
  end

  it "shows the error" do
    expect(json_body["error"]["message"]).to be_present
  end

end


shared_examples "a nice V3 404 response" do

  it "has status 404" do
    expect(response.status).to eq(404)
  end


end

shared_examples "a correctly formatted token" do

  it "has status 404" do
    expect(response.status).to eq(404)
  end

  it "shows the error" do
    expect(json_body["error"]["message"]).to be_present
  end
end

shared_examples "a correctly formatted oauth token" do

  it "has status 401" do
    expect(response.status).to eq(401)
  end

end
