module Nu
  module Calculate

    # Calculate Nu Activity Score from activity measurements.
    class Activity
      def initialize(user, date=Date.current)
        @user = user
        @date = date
        @score = 0
      end

      def score
        if @user.preferences.where(name: "use_health_data", value: "true").present? && @user.activity_measurements.present? || @user.step_measurements.present?
          calculate_from_measurements
        else
          @score = case @user.activity
                   when 1 then 20
                   when 2 then 37
                   when 3 then 55
                   when 4 then 72
                   when 5 then 90
                   else 0
                   end
        end

        # score cannot exceed 100 points
        @score > 100 ? 100 : @score
      end

      # Convert the score into a multiplier used to calculate Daily Caloric Need.
      def laf
        BigDecimal.new(score) / 100 + 1
      end

      private

      def calculate_from_measurements
        # For the Moves activities
        @user.activity_measurements.where(date: @date).each do |measurement|
          if measurement.type == "walking"
            # each walking minute is worth daily activity minutes
            @score += (measurement.duration.to_f * 100 / 4500).to_f
          elsif measurement.type == "running" || measurement.type == "cycling"
            # for vigorous activities, divide by smaller number to give twice the score
            @score += (measurement.duration.to_f * 100 / 2200).to_f
          elsif measurement.type == "calories"
            unless dcn_measurement == 0.0
              @score += ((measurement.calories * 100) / dcn_measurement).round
            else
              @score += calories_score(measurement.calories)
            end
          elsif measurement.type == "steps"
            @score += (measurement.steps.to_f * 100 / 20000).round
          end
        end

        # For the internal step counter
        @user.step_measurements.where(date: @date).each do |measurement|
          @score += (measurement.value.to_f * 100 / 20000).round
        end
      end


      def dcn_measurement
        @user.historical_scores.find_by(date: Date.current).try(:dcn).to_f
      end

      def calories_score(calories)
        if @user.sex == 'M' || @user.sex.nil?
          if calories >= 0 && calories < 500
            22
          elsif calories >= 500 && calories < 1000
            33
          elsif calories >= 1000 && calories < 1500
            56
          elsif calories >= 1500 && calories < 2000
            73
          elsif calories >= 2000 && calories < 2500
            85
          elsif calories >= 2500
            100
          end
        elsif
          @user.sex == 'F'
          if calories >= 0 && calories < 400
            22
          elsif calories >= 400 && calories < 900
            33
          elsif calories >= 900 && calories < 1300
            56
          elsif calories >= 1300 && calories < 1700
            73
          elsif calories >= 1700 && calories < 2000
            85
          elsif calories >= 2000
            100
          end
        end
      end


    end
  end
end
