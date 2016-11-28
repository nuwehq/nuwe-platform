# Gamified awards that Teams receive for any number of things.
# The +name+ field is a string that needs to be translated into something human.
class Achievement < ActiveRecord::Base

  belongs_to :team

end
