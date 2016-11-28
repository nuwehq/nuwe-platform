module Measurement
  class BloodPressure < ActiveRecord::Base
    belongs_to :user

    validates :user, presence: true
    validates :date, presence: true

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['blood_pressure'] = user.last_blood_pressure_measurement.value
      user.save
    end
  end
end
