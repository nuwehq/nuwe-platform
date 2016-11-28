require 'grocer'

namespace :apns do
  task feedback: :environment do
    feedback = Grocer.feedback(
      certificate:      ENV['APNS_CERTIFICATE_PATH']
    )

    feedback.each do |attempt|
      Device.where(token: attempt.device_token).destroy_all
    end
  end
end
