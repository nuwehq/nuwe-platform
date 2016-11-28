module Measurement
  class BodyFat < ActiveRecord::Base
    belongs_to :user

    validates :user, presence: true
    validates :date, presence: true

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['body_fat'] = user.last_body_fat_measurement.value
      user.save
    end
  end
end
