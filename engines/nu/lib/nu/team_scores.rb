module Nu

  # Calculate all scores for a given day for the given user
  class TeamScores
    def initialize(date, team)
      @date = date
      @team = team
    end

    # A hash with values for all the scores.
    # This hash is used directly as the JSON API result, so be careful not to change the interface.
    def result
      {
        date:                   @date,
        biometric_score:        {score: score.biometric },
        activity_score:         {score: score.activity },
        nutrition_score:        {score: score.nutrition },
        nu_score:               {score: score.nu }
      }
    end

    private

    def score
      @score ||= @team.historical_scores.where("date <= ?", @date).order(:created_at).last || HistoricalScore.new
    end


  end
end
