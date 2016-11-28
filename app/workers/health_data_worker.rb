require 'pusher'

# Fetch health data from the app in question and store it in the user's profile.
class HealthDataWorker
  include Sidekiq::Worker

  def perform(app_id, options={})
    @app = App.find app_id
    @options = options

    send(@app.provider)

    begin
      Measurement::HistoricalWorker.new(@app.user).perform
    rescue ArgumentError => error
      # No DCN or gender available.
      Rails.logger.warn error.message
    end
  end

  private

  def humanapi
    Measurement::Humanapi.synchronize(@app, @options)
  end

  def moves
    Measurement::Moves.new(@app, @options).synchronize
  end

  def fitbit
    Measurement::Fitbit.new(@app, @options).synchronize
  end

  def withings
    Measurement::Withings.new(@app, @options).synchronize
  end

  def m7
    #this is handled by the app which automatically posts steps
  end

end
