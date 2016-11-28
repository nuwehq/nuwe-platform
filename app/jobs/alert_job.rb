class AlertJob < ActiveJob::Base

  # Creates a notification and delivers it.

  def perform(alert)

    if alert.recipients == :all
      Doorkeeper::AccessGrant.where(application: alert.application).group_by(&:resource_owner_id).each do |resource_owner_key, value|

        user = User.find resource_owner_key
        deliver_notification(user, alert)
      end

    elsif alert.recipients == :user
      user_email = alert.engine.match(/(?<email>(\b([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+?)(\.[a-zA-Z.]*)\b))/i).to_s.downcase
      user = User.find_by email: user_email

      # Shouldn't send a notification if user doesn't exist or there isn't an access grant.
      if user && Doorkeeper::AccessGrant.where(application: alert.application).where(resource_owner_id: user.id).present?
        deliver_notification(user, alert)
      end
    end
  end

  private

  def deliver_notification(user, alert)
    notification = ProcessNotificationMessage.new(alert, user).transform

    # Creates a push notification for iOS!
    if alert.type == :push_notification
      NotificationJob.perform_later(notification, alert.application)
    # Creates an email notification.
    elsif alert.type == :email
      NotificationMailer.alert(notification.id, alert.application.id).deliver_later
    end
  end
end
