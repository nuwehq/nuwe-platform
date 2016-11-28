class Invitation < ActiveRecord::Base

  validates :email, presence: true

  belongs_to :team
  belongs_to :user

end
