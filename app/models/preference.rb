# This class is pretty self-explanatory I would hope. <3
class Preference < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :name

end
