# A Push Notification to all members of a Team.
class TeamNotification < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates :text, presence: true
  validates :user, presence: true

  # All team members except the sender.
  def recipients
    team.users.where.not(id: user.id)
  end
end
