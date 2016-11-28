# The four type of scores for any full day in the past.
class HistoricalScore < ActiveRecord::Base

  validates :date, presence: true

  belongs_to :history, polymorphic: true

  def laf
    if activity.present?
      BigDecimal.new(activity) / 100 + 1
    else
      1
    end
  end

  def dcn
    Measurement::DcnCalculator.calculate(history, date)
  end

  def bmr
    Measurement::BmrCalculator.calculate(history, date)
  end

  def day_before
    history.historical_scores.where(date: date - 1.day).last
  end

  def day_tomorrow
    history.historical_scores.where(date: date + 1.day).first
  end

end
