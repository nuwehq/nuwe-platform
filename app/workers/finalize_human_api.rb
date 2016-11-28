require 'sidekiq'
require 'httparty'

# Finalize the Human API authentication flow.
# POST the client-side values to Human API to receive the user's
# access token to access all health data.
class FinalizeHumanApi

  include Sidekiq::Worker
  include HTTParty

  base_uri 'https://user.humanapi.co'

  headers 'Content-Type' => 'application/json'

  def perform(params, user_id)
    @params = params
    @response = self.class.post "/v1/connect/tokens", body: credentials

    @user = User.find user_id
    @user.apps.create! attributes
  end

  private

  # Whitelist attributes to send to Human API and add the client secret.
  def credentials
    @params.slice("humanId", "clientId", "sessionToken").merge("clientSecret" => ENV['HUMANAPI_CLIENT_SECRET']).to_json
  end

  # Translate the Human API response into an attributes hash to create an App.
  def attributes
    {
      provider: "humanapi",
      uid: @response["humanId"],
      credentials: @response.to_hash
    }
  end

end
