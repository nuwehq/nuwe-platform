class Alert < ActiveRecord::Base

  belongs_to :application, class_name: 'Doorkeeper::Application'

  validates_presence_of :text
  validates_presence_of :engine

  # Determines if an alert needs to be sent as a push notification or an email
  def type
    if engine.include? '{{email}}'
      :email
    elsif engine.include? '{{push_notification}}'
      :push_notification
    end
  end

  def recipients
    if engine.include? "{{all_users}}"
      :all
    elsif engine.match(/{{user:/)
      :user
    end
  end

end
