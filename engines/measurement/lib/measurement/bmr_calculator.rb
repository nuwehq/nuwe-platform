module Measurement
  # Calculate the Base Metabolic Rate.
  # The parameters should ideally be BigDecimals.
  class BmrCalculator

    # Expects weight in kg, height in cm and age in years.
    def initialize(weight, height, age, sex)
      @weight, @height, @age, @sex = weight, height, age, sex
    end

    # Calculate the BMR for the given user on the given date
    # and store it as a measurement in the database.
    def self.calculate(user, date)
      bmr = new(user.weight_kg(date), user.height_cm(date), user.age, user.sex)

      user.bmr_measurements.where(date: date).destroy_all
      user.bmr_measurements.create!({
        date:           date,
        timestamp:      Time.current,
        value:          bmr.value,
        unit:           bmr.unit,
        source:         bmr.source
      })
    end

    # Calculated according to Mifflin.
    #   (MD Mifflin, ST St Jeor, et al. A new predictive equation for resting energy expenditure in healthy individuals. J Am Diet Assoc 2005:51:241-247.)
    def value
      # If any of the inputs is unknown, return +nil+ as the value, meaning we don't know the BMR.
      return nil if @weight.nil? || @height.nil? || @age.nil? || @sex.nil?

      base_bmr + gender_adjustment
    end

    def unit
      "kcal/day"
    end

    def source
      "nutribu"
    end

    private

    def base_bmr
      (10 * @weight.to_f) + (6.25 * @height.to_f) - (5 * @age)
    end

    def gender_adjustment
      if @sex == 'M'
        5
      elsif @sex == 'F'
        -161
      end
    end
  end
  
end
