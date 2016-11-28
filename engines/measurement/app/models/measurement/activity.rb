module Measurement
  # Activity as measured by various devices.
  class Activity < ActiveRecord::Base
    belongs_to :user

    # we have a `type` column for the activity type, and we are not using STI
    self.inheritance_column = nil
  end
end
