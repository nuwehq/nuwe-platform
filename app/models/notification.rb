class Notification < ActiveRecord::Base
  belongs_to :recipient, class_name: "User" # recipient_id

  def recipients
    [recipient]
  end
end
