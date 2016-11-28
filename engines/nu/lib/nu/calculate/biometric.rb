module Nu
  module Calculate

    # Calculate Nu Biometric Score from BMI prime.
    # https://docs.google.com/spreadsheets/d/180vloFyx3KCDupwY6araS-XO34Py91LgM7ar4_vbxcE/edit#gid=0
    class Biometric
      def initialize(bmi_measurement)
        @bmi_measurement = bmi_measurement
      end

      def score
        if @bmi_measurement.present? && prime > 0.0
          prime_lookup = Nu::BmiPrimeLookup.new(prime)
          prime_lookup.value
        else
          return nil
        end
      end

      def freshness
        return nil unless @bmi_measurement

        freshness = 100
        days_since = ( Date.current - @bmi_measurement.date ).to_i
        freshness = freshness - 5 * days_since
        freshness = 0 if freshness < 0
        freshness
      end

      private

      def prime
        @bmi_measurement.prime
      end
    end

  end
end
