# v1 and v2 API: access a user directly
shared_context "signed up user" do
  let(:user) { FactoryGirl.create :user }
end

# v3 API: use OAuth2 with separate developer/user
shared_context "signed up developer" do
  let(:developer) { FactoryGirl.create :developer }
  let(:oauth_application) { FactoryGirl.create :oauth_application, owner: developer}
end

shared_context "authenticated user" do
  let(:oauth_user) { FactoryGirl.create :oauth_user }
end

shared_context "signed up admin" do
  let(:user) { FactoryGirl.create :admin }
end

# For V3 Authentication
shared_context "bearer token authentication" do
  let(:access_token)  { Doorkeeper::AccessToken.create!(application: oauth_application, :resource_owner_id => oauth_user.id ) }

  def bearer_auth
    { "HTTP_AUTHORIZATION" => "Bearer #{access_token.token}" }
  end

  def application_auth
    { "HTTP_AUTHORIZATION" => "application_id #{oauth_application.uid}, client_secret #{oauth_application.secret}" }
  end

  def invalid_app_auth
    { "HTTP_AUTHORIZATION" => "application_id 092398wefhiuhwef, application_secret 89843879y43y89efhiu" }
  end

  def invalid_bearer_auth
    { "HTTP_AUTHORIZATION" => "Bearer not a real token" }
  end

end

# For V1 & V2 authentication
shared_context "api token authentication" do
  let(:token) { user.tokens.where(scope: "api").first }

  def token_auth
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(token.id) }
  end

  def invalid_token_auth
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials("meowmeowmeow") }
  end

end

# clear the cache before every request.
# the cache is used to store connection attempts,
# so by clearing it we don't trigger a throttle block.
shared_context "throttle" do
  before do
    Rails.cache.clear
  end
end

shared_context "pusher" do
  before do
    expect(Pusher).to receive(:trigger).at_least(:once)
  end
end
