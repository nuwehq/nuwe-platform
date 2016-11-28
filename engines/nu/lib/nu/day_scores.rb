module Nu

  # Calculate all scores for a given day for the given user
  class DayScores
    def initialize(date, user)
      @date = date
      @user = user
      @dcn = @user.historical_scores.find_by(date: Date.current).try(:dcn).to_f
    end

    # A hash with values for all the scores.
    # This hash is used directly as the JSON API result, so be careful not to change the interface.
    def result
      {
        date:                   @date,
        biometric_score:        {score: score.biometric},
        activity_score:         {score: score.activity},
        nutrition_score:        {score: score.nutrition},
        nu_score:               {score: score.nu},
        breakdown:              {breakdown: breakdown}
        
      }
    end

    private

    def breakdown
      unless @dcn == 0.0
        Nutrition::Calculate::Breakdown.new(@user, @date).results
      end
    end

    def score
      @score ||= @user.historical_scores.where("date <= ?", @date).order(:created_at).last || HistoricalScore.new
    end

  end

end
