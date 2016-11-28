module Measurement
  class Bpm < ActiveRecord::Base
    belongs_to :user

    validates :user, presence: true
    validates :date, presence: true

    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['bpm'] = user.last_bpm_measurement.value
      user.save
    end
  end
end
