class NotificationMailer < ActionMailer::Base
  default from: "tech@nuwe.co"

  def alert(notification_id, application_id)
    @notification = Notification.find notification_id
    @application = Doorkeeper::Application.find application_id
    @recipient = @notification.recipient

    mail(to: @recipient.email, subject: "New Notification from #{@application.name}")
  end

end
