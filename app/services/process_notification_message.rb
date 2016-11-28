class ProcessNotificationMessage
# Transform variables in an alert message so that they are personalized in the notification sent to users.

  def initialize(alert, user)
    @notification = Notification.new recipient: user, message: alert.text
  end

  def transform
    # will run through some private methods here to transform the message into a personalized one:
    first_name

    @notification.save!
    @notification
  end

  private

  def first_name
    if @notification.message.include? '{{first_name}}'
      @notification.message.gsub!('{{first_name}}', @notification.recipient.first_name || 'user')
    end
  end
end
