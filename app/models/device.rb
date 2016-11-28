# Physical device such as a phone or tablet.
# The +token+ field is a Apple Push Notification device token, in the
#   format "<ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969>"
class Device < ActiveRecord::Base

  validates :token, uniqueness: true

  belongs_to :user

end
