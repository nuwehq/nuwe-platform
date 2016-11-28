module Measurement
  # Process all measurements into scores and derived measurements for the past month.
  class HistoricalWorker
    def initialize(user, start_date=1.month.ago.to_date, end_date=Date.current)
      @user             = user
      @start_date       = start_date
      @end_date         = end_date
    end

    def perform
      @start_date.upto(@end_date) do |date|
        Measurement::BmrCalculator.calculate(@user, date)
        Nu::Score.new(@user).daily_scores(date)
        Measurement::DcnCalculator.calculate(@user, date)
      end

      # Push the new scores to intercom.io
      IntercomWorker.perform_async(@user.email, {
        biometric_score:       @user.biometric_score,
        activity_score:        @user.activity_score,
        nutrition_score:       @user.nutrition_score,
        nu_score:              @user.nu_score
      })
    end
  end
end
