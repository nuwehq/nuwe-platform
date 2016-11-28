def create_user_request(email: "me@example.com", password: "supersecret", **options)
  user = {email: email, password: password}.merge(options)
  VCR.use_cassette "users/create" do
    post "/v1/users.json", user: user
  end
end
