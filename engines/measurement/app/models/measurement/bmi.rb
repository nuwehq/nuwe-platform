module Measurement
  # The Body Mass Index.
  # http://en.wikipedia.org/wiki/Body_mass_index
  class Bmi < ActiveRecord::Base

    PRIME_FACTOR = 25

    belongs_to :user

    validates_presence_of :date
    validates_presence_of :timestamp
    validates_presence_of :value
    validates_presence_of :unit
    validates_presence_of :source

    before_save :calculate_prime

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['bmi'] = user.last_bmi_measurement.value
      user.save
    end

    def calculate_prime
      self.prime = value / PRIME_FACTOR
    end

  end
end
