require 'interactor'

# update the user's scores, since she might have given new measurements in the update.
# Extracted from ProfileUpdate.
# OPTIMIZE find out why this needs to be called twice in ProfileUpdate.
class CalculateMissingDcn

  include Interactor

  def call
    if context.user.historical_scores.find_by(date: Date.current).try(:dcn).nil?
      Nu::Score.new(context.user.reload).daily_scores(Date.current)
    end
  end

end
