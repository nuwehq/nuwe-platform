module Measurement

  # Calculate the Daily Caloric Need.
  # It's the BMR for that day times the LAF.
  class DcnCalculator

    def initialize(bmr, laf)
      @bmr, @laf = bmr, laf
    end

    def self.calculate(user, date)
      bmr = user.bmr_measurements.find_by(date: date).try(:value)
      laf = user.historical_scores.find_by(date: date).try(:laf)

      new(bmr, laf).value
    end

    def value
      return nil if @bmr.nil? || @laf.nil?
      @bmr * @laf
    end



  end
end
