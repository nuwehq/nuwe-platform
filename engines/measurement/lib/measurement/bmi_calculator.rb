module Measurement
  # Calculate BMI from given weight and height.
  # The parameters should ideally be BigDecimals.
  class BmiCalculator

    # Expects weight in kg and height in m.
    def initialize(weight, height)
      @weight = weight
      @height = height
    end

    def value
      @weight / @height ** 2
    end

  end
end
