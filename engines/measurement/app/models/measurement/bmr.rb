module Measurement
  # The rate of energy expenditure by humans and other animals at rest, and is measured in kcal per day.
  class Bmr < ActiveRecord::Base

    belongs_to :user

    validates_presence_of :date
    validates_presence_of :timestamp
    validates_presence_of :unit
    validates_presence_of :source

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['bmr'] = user.last_bmr_measurement.value
      user.save
    end
  end
end
