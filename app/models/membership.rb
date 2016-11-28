# Has-many-through model between Team and User, signaling team membership
class Membership < ActiveRecord::Base

  validates :user, presence: true
  validates :team, presence: true

  belongs_to :user
  belongs_to :team

end
