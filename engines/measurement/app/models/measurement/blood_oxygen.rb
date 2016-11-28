module Measurement
  class BloodOxygen < ActiveRecord::Base
    belongs_to :user

    validates :user, presence: true
    validates :date, presence: true

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['blood_oxygen'] = user.last_blood_oxygen_measurement.value
      user.save
    end
  end
end
