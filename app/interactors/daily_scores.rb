require 'interactor'

# Calculate daily scores for a user for the current date.
#
# Used in ProfileUpdate.
class DailyScores

  include Interactor

  def call
    Nu::Score.new(context.user.reload).daily_scores(Date.current)
  end

end
