class Eats::CalculateDailyScores
  include Interactor

  def call
    Nu::Score.new(context.user).daily_scores(Date.current)
  end

end
