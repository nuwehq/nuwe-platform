module Measurement
  class Height < ActiveRecord::Base
    belongs_to :user

    validates_presence_of :date
    validates_presence_of :timestamp
    validates_presence_of :value
    validates_presence_of :unit
    validates_presence_of :source

    after_create :create_missing_bmi_measurements
    after_create :update_user_measurements

    private

    def update_user_measurements
      user.measurements['height'] = user.last_height_measurement.value
      user.measurements_will_change! # https://github.com/rails/rails/issues/6127
      user.save
    end

    # Imagine that someone has created lots of weight measurements in the past, but never
    # registered a height measurement. As such we have never been able to determine their BMI.
    # But! A height measurement appears! This means we can retroactively calculate the BMI
    # from the point in time of the height measurement onwards.
    def create_missing_bmi_measurements
      date.upto(Date.current) do |date|
        if user.bmi_measurements.where(date: date).empty?
          user.weight_measurements.where(date: date).find_each do |weight_measurement|
            user.bmi_measurements.create! value: BmiCalculator.new(weight(weight_measurement), height).value, timestamp: weight_measurement.timestamp, source: "nuapi", date: date, unit: "kg/m2"
          end
        end
        if user.age.present? && user.sex.present?
          user.bmr_measurements.create! value: Measurement::BmrCalculator.new(user.weight, user.height, user.age, user.sex).value, timestamp: Time.current, source: "nuapi", date: date, unit: "kcal/day"
        end
      end
    end

    # BMI calculation works with m for height.
    def height
      value / 1000
    end

    # And with kg for weight.
    def weight(weight_measurement)
      if weight_measurement.unit == "grams"
        weight_measurement.value / 1000
      elsif weight_measurement.unit == "kg"
        weight_measurement.value
      else
        raise "Unknown unit: #{weight_measurement.unit} for weight measurement #{weight_measurement.id}"
      end
    end
  end
end
