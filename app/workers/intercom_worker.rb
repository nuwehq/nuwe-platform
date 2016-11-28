require 'intercom'

# Push custom attributes to intercom.io
class IntercomWorker
  include Sidekiq::Worker

  # Needs the user's email address.
  # Optional a {Hash} of key-values to store as custom attributes.
  def perform(email, attributes={})
    user = intercom.users.create email: email

    attributes.each_pair do |key, value|
      user.custom_attributes[key] = value
    end

    intercom.users.save(user)
  end

  def intercom
    Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'], api_key: ENV['INTERCOM_APP_API_KEY'])
  end

end
