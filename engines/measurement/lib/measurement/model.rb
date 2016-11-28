require 'active_support/concern'

module Measurement
  # Provides methods to ActiveRecord models in the host app.
  module Model
    extend ActiveSupport::Concern

    TYPES = %i(height weight bmi bmr activity bpm blood_pressure step blood_oxygen body_fat)

    included do

      TYPES.each do |type|
        has_many "#{type}_measurements".to_sym, class_name: "Measurement::#{type.to_s.classify}"
      end
    end

    TYPES.each do |type|
      # Define a getter for the measurement value.
      # Do not use accessors! The writers need to perform a specific function (see below).
      define_method type do
        measurements[type.to_s]
      end

      # Define a relation for the last measurement of the given type.
      define_method "last_#{type}_measurement" do                       # def last_weight_measurement
        send("#{type}_measurements").order(timestamp: :desc).first      #   weight_measurements.order(timestamp: :desc).first
      end                                                               # end
    end

    def bmi_prime
      if bmi_measurements.present?
        last_bmi_measurement.prime
      end
    end

    def weight=(value)
      weight_measurements.create! value: value, unit: "grams", source: "nuapi", date: Date.current, timestamp: Time.now
    end

    def height=(value)
      height_measurements.create! value: value, unit: "millimeter", source: "nuapi", date: Date.current, timestamp: Time.now
    end

    def bpm=(value)
      bpm_measurements.create! value: value, date: Date.current, timestamp: Time.now
    end

    def blood_pressure=(value)
      blood_pressure_measurements.create! value: value, date: Date.current, timestamp: Time.now
    end

    def blood_oxygen=(value)
      blood_oxygen_measurements.create! value: value, date: Date.current, timestamp: Time.now
    end

    def body_fat=(value)
      body_fat_measurements.create! value: value, date: Date.current, timestamp: Time.now
    end

    # Most recent weight since the given date.
    def weight_kg(date = Date.current)
      weight = weight_measurements.order(:date).where("date <= ?", date).last

      weight.value / 1000 if weight
    end

    # Most recent height since the given date.
    def height_cm(date = Date.current)
      height = height_measurements.order(:date).where("date <= ?", date).last

      height.value / 10 if height
    end

  end
end
