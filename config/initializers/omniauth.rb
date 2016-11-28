Rails.application.config.middleware.use OmniAuth::Builder do
  provider :moves, ENV['MOVES_KEY'], ENV['MOVES_SECRET'], {provider_ignores_state: true}
  provider :fitbit, ENV['FITBIT_KEY'], ENV['FITBIT_SECRET']
  provider :withings, ENV['WITHINGS_KEY'], ENV['WITHINGS_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user"
end
