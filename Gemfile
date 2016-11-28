source 'https://rubygems.org'

ruby '2.1.4'

# rails
gem 'rails', '4.2.4'

# assets
gem 'sass-rails', require: false
gem 'sassc-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'bourbon'
gem 'lodash-rails'
gem "autoprefixer-rails"
gem 'ionicons-rails'


# database
gem 'pg'

# engines
gem 'measurement', path: 'engines/measurement'
gem 'nu', path: 'engines/nu'
gem 'nutrition', path: 'engines/nutrition'

# gems the app needs
gem 'sidekiq_snitch'
gem "active_model_serializers", "~> 0.8.2" # 0.9.x branch is not usable
gem 'versionist'
gem 'bcrypt', '~> 3.1.7'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'remotipart'
gem 'jbuilder', '~> 2.0'
gem 'rack-attack'
gem 'interactor'
gem 'interactor-rails'
gem 'slim-rails'
gem 'sidekiq', '< 5'
gem 'httparty'
gem 'whenever', require: false
gem 'paperclip', '~> 4.3'
gem 'kaminari'
gem 'airbrake'
gem 'pusher'
gem 'api-pagination'
gem 'grocer'
gem 'intercom', '~> 3.0.2'
gem 'rest-client'
gem 'ruby-hmac'
gem 'roadie-rails'
gem 'intercom-rails'
gem 'font-awesome-sass'
gem 'rails-i18n', '~> 4.0.0'
gem 'responders', '~> 2.0'
gem 'country_select', '2.2.0'
gem 'searchkick'
gem 'aws-sdk', '~> 2'

# providers
gem 'fitgem'
gem 'simplificator-withings'
gem 'factual-api'
gem 'stripe'

# oauth2
gem 'omniauth'
gem 'omniauth-moves'
gem 'omniauth-fitbit', github: "spacebabies/omniauth-fitbit"
gem 'omniauth-withings'
gem 'omniauth-github'
gem 'doorkeeper', '2.1.3'

group :development do
  gem 'spring'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'webmock'
  gem 'vcr'
  gem 'timecop'
  gem 'poltergeist'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'figaro'
  gem 'faker'
  gem 'rspec-rails'
end
