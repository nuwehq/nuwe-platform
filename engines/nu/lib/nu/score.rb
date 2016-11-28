module Nu
  class Score

    TYPES = %i(activity nutrition biometric)

    def initialize(user)
      @user = user
    end

    # Calculate the Nu Scores for the past month, excluding today.
    def calculate
      1.month.ago.to_date.upto(Date.yesterday) do |date|
        daily_scores(date)
      end
    end

    # Calculate the Nu Scores for the given day.
    def daily_scores(date)
      score             = @user.historical_scores.find_or_initialize_by(date: date)

      # biometrics.
      # score for any given day is determined via the last known BMI measurement for the given day.
      bmi_measurement   = @user.bmi_measurements.where("date <= ?", date).order(:created_at).last
      score.biometric   = Nu::Calculate::Biometric.new(bmi_measurement).score

      # activities
      # score is determined by all activity measurements for the given day.
      # FIXME should take past 7 days into account
      calculation       = Nu::Calculate::Activity.new(@user, date)
      score.activity    = calculation.score

      # Save score here, so historical activity score is stored,
      # otherwise there is no LAF on the very first profile update
      # resulting in no DCN
      score.save!
      
      # Measurements needed for Breakdown
      Measurement::BmrCalculator.calculate(@user, date)

      begin
        # nutrition
        # score is determined by all nutritional measurements for the given day.
        nutrition         = Nutrition::Calculate::Breakdown.new(@user, date)
        score.nutrition   = nutrition.score
      rescue
        # so that bio and activity can always be saved,
        # and when user has no age, etc, the nutrition historical score will be nil.
      end

      nutri = score.nutrition || 0
      acti  = score.activity  || 0
      biom  = score.biometric || 0

      score.nu   = (nutri + acti + biom ).to_f / 3

      score.save!

      ## update the user's score fields with the most recent score known
      @user.biometric_score = @user.historical_scores.where(date: 7.days.ago..Date.yesterday).average(:biometric)
      @user.activity_score = @user.historical_scores.where(date: 7.days.ago..Date.yesterday).average(:activity)
      @user.nutrition_score = @user.historical_scores.where(date: 7.days.ago..Date.yesterday).average(:nutrition)

      b = @user.biometric_score || 0
      a = @user.activity_score || 0
      n = @user.nutrition_score || 0
      @user.nu_score        = (b+a+n).to_f / 3
      @user.save!
    end
  end
end
