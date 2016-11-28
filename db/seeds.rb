Subscription.create(
  name: "DEV",
  description: "Full access to all features in development environment",
  user_limit: 1000,
  api_call_limit: 10000,
  storage: 25,
  support: "Forum Support")

Subscription.create(
  name: "Launch",
  price: 149,
  description: "Full access to all features in production environment",
  user_limit: 10000,
  api_call_limit: 1000000,
  storage: 25,
  support: "Email Support")

Subscription.create(
  name: "Scale",
  price: 449,
  description: "Perfect for when you start to really get traction",
  user_limit: 100000,
  api_call_limit: 10000000,
  storage: 25,
  support: "Phone & Email Support")

Subscription.create(
  name: "Unicorn",
  price: 2499,
  description: "A rapidly scaling company is a challenge. We've got your back.",
  storage: 25,
  support: "Dedicated Account Manager")

data = ServiceCategory.create(
  name: "Data"
)

intelligence = ServiceCategory.create(
  name: "Intelligence"
)

security = ServiceCategory.create(
  name: "Security"
)

tools = ServiceCategory.create(
  name: "Tools"
)

# This service is REQUIRED for developer portal to run without error
tools.services.create!(
  name: "Parse Server",
  description: "A full PaaS for your apps",
  lib_name: "parse_core",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

# These services are optional for developer portal to run, but may effect availability of related API endpoints.
intelligence.services.create!(
  name: "Prediction.IO",
  description: "Machine learning tools for recommender systems and predictive analytics",
  coming_soon: true,
  icon: File.open('app/assets/images/PredictionIO.png'))

data.services.create!(
  name: "Factual UPC",
  description: "Over 600,000 consumer packaged goods in a UPC centric database",
  needs_remote_credentials: true,
  icon: File.open('app/assets/images/factual.png'))

data.services.create!(
  name: "Factual Places",
  description: "Over 65 million businesses and points of interest",
  icon: File.open('app/assets/images/factual.png'))

data.services.create!(
  name: "Nuwe Ingredients",
  description: "National nutritional database",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Nuwe Meals",
  description: "User generated meals data with nutrition",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Nuwe Places",
  description: "Location data for your app",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

security.services.create!(
  name: "Nuwe Security - Standard",
  description: "High quality security standards, ideal for early stage development",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

security.services.create!(
  name: "Nuwe Security - HIPAA",
  description: "Compliant data security services for the US market",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

security.services.create!(
  name: "Nuwe Security - UK",
  description: "Compliant data security services for the UK market",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

security.services.create!(
  name: "Nuwe Security - EU",
  description: "Compliant data security services for the majority of EU markets",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

tools.services.create!(
  name: "Pusher",
  description: "Realtime push notifications for your app",
  icon: File.open('app/assets/images/pusher.png'))

data.services.create!(
  name: "Nuscore",
  description: "Quantify wellness with the Nuscore health scoring system",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Nuwe Nutrition",
  description: "Tracking eats and nutritional data for your users",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Nuwe Teams",
  description: "Create and manage Groups and Teams of Users",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Nuwe Wearables",
  description: "Get started with wearables data from Withings, Moves and FitBit",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Human API",
  description: "Integrate with 20 different wearables data sources, including Jawbone, Moves, Garmin, Strava and FitBit",
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

data.services.create!(
  name: "Validic",
  description: "Integrate with over 20 different wearables data sources, including Runkeeper, Moves, iHealth and Nike +",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

intelligence.services.create!(
  name: "Cubitic",
  description: "Take a proactive approach to engaging your users, by knowing what they'll do before they do it.",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

intelligence.services.create!(
  name: "Seldon",
  description: "Seldon is an open-source predictive analytics platform for delivering the most personalised experience for each individual.",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

security.services.create!(
  name: "Chino",
  description: "Chino provides data storage services for European data storage compliance.",
  coming_soon: true,
  icon: File.open('app/assets/images/AppIcon76x76@2x.png'))

admin = User.create!({
  email: "admin@example.com",
  name: "Admin",
  password: "letmeinplease",
  roles: ["admin", "developer"]
  })

developer = User.create!({
  email: "developer@example.com",
  name: "Developer",
  password: "letmeinplease",
  roles: ["developer"]
  })

user = User.create!({
  email: "user@example.com",
  name: "User",
  password: "letmeinplease"
  })

DoorkeeperInteractor::DoorkeeperApplication.call(application_params: {name: "My First App"}, user: admin)
DoorkeeperInteractor::DoorkeeperApplication.call(application_params: {name: "My First App"}, user: developer)

admin_app = admin.oauth_applications.first
admin_device = admin_app.medical_devices.create!({
    name: "Admins's medical device",
    enabled: true
    })

data1 = admin_device.device_results.create!({
  data: [{"temperature"=>"24","humidity"=>"26","created_at"=>"2015-09-23T09:07:51.628Z"}]
  })

data2 = admin_device.device_results.create!({
  data: [{"temperature"=>"24","humidity"=>"26","created_at"=>"2015-09-23T09:07:51.628Z"}]
  })


admin_device.column_values.create!({
  field_name: "temperature",
  type: "integer",
  read_only: false,
  editor: "text"
  })


admin_device.column_values.create!({
  field_name: "humidity",
  type: "integer",
  read_only: true,
  editor: "text"
  })

admin_device.column_values.create!({
  field_name: "created_at",
  type: "date",
  read_only: true,
  editor: "datePicker"
  })

profile = Profile.create!({
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  sex: "M",
  birth_date: "1984-01-28",
  activity: 4
  })
# user has a profile
user.update_attributes(profile: profile)

# user authorizes app
Doorkeeper::AccessToken.create!(application: admin_app, :resource_owner_id => user.id)
Doorkeeper::AccessGrant.create!(resource_owner_id: user.id, application_id: admin_app.id, redirect_uri: admin_app.redirect_uri, expires_in: 600)

# user has measurements
user.bmi_measurements.create value: 22, unit: "kg/m2", source: "nutribu", date: Date.yesterday, timestamp: Time.current
user.bmr_measurements.create value: 1442, unit: "kcal/day", source: "nutribu", date: 4.days.ago, timestamp: Time.current
user.height_measurements.create value: 1920, unit: "mm", source: "self-measurement", date: Date.yesterday, timestamp: Time.current
user.weight_measurements.create value: 8800, unit: "grams", source: "self-measurement", date: Date.yesterday, timestamp: Time.current
user.bpm_measurements.create value: 60, date: Date.yesterday, timestamp: Time.current
user.step_measurements.create value: 150, date: Date.yesterday, timestamp: Time.current
user.blood_pressure_measurements.create value: "120/80", date: Date.yesterday, timestamp: Time.current
user.blood_oxygen_measurements.create value: "99", date: Date.yesterday, timestamp: Time.current
user.body_fat_measurements.create value: 24.5, date: Date.yesterday, timestamp: Time.current

puts "Seed Complete for sake of Steve's Sanity, here's proof in the console."
