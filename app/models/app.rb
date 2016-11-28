# Represents an OAuth application the user has connected with.
class App < ActiveRecord::Base

  belongs_to :user

  validates :uid,       presence: true
  validates :provider,  presence: true, uniqueness: { scope: :user_id }

end
