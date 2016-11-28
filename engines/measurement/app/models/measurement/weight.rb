module Measurement
  class Weight < ActiveRecord::Base
    belongs_to :user

    validates_presence_of :date
    validates_presence_of :timestamp
    validates_presence_of :value
    validates_presence_of :unit
    validates_presence_of :source

    after_create :update_user_measurements, :create_bmi_measurement

    private

    def update_user_measurements
      user.measurements['weight'] = user.last_weight_measurement.value
      user.save
    end

    # Every weight measurement results in a corresponding BMI calculation,
    # as long as there is a value for the height of the user.
    def create_bmi_measurement
      if user.height.present? && user.height.to_f > 0.1
        user.bmi_measurements.create! value: BmiCalculator.new(weight, height).value, timestamp: timestamp, source: "nuapi", date: date, unit: "kg/m2"
      end
      if user.age.present? && user.sex.present?
        user.bmr_measurements.create! value: Measurement::BmrCalculator.new(user.weight, user.height, user.age, user.sex).value, timestamp: Time.current, source: "nuapi", date: date, unit: "kcal/day"
      end
    end

    # BMI calculation works with kg for weight.
    def weight
      if unit == "grams"
        value / 1000
      elsif unit == "kg"
        value
      else
        raise "Unknown unit: #{unit} for weight measurement #{id}"
      end
    end

    # BMI calculation works with m for height.
    def height
      user.height.to_f / 1000
    end

  end
end
