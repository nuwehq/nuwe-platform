require 'grocer'

# Actually relay a created Notification to the Push Notification service.
class NotificationJob < ActiveJob::Base
  queue_as :default

  # We no longer use Grocer for push notifications, the plan is to move the whole Push Service to a Parse-Server service for the application.
  # But you can choose to reinstate this core notification capability if you prefer to do it this way.
  def perform(notification, application)
    @notification = Notification.find(notification.id)
    @application = Doorkeeper::Application.find(application.id)
    @notification.recipients.each do |user|
      user.devices.each do |device|
        apn = Grocer::Notification.new(
          device_token:         device.token,
          alert:                alert
        )

        pusher.push(apn)
      end
    end
  end

  private

  def pusher
    @pusher ||= Grocer.pusher(
      #certificate:      ENV['APNS_CERTIFICATE_PATH']
      certificate:      @application.apns_certificate
    )
  end

  # Team notification and notification have differently named message fields.
  # Determines what kind of notification it is so that the correct field is called.
  def alert
    if @notification.is_a? TeamNotification
      # If the first name is known, prefix the message with it.
      if @notification.user.first_name
        "#{@notification.user.first_name}: #{@notification.text}"
      else
        @notification.text
      end
    elsif @notification.is_a? Notification
      @notification.message
    end
  end

end
