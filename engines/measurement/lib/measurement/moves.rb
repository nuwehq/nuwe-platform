require 'moves'
require 'date'

module Measurement

  # Synchronize health data from Moves.
  class Moves

    PAST_DAYS = 31

    def initialize(app, options={})
      @app = app
      @options = options
      @measurements = []
    end

    def synchronize
      moves = ::Moves::Client.new @app.credentials['token']

      begin
        moves.profile
      rescue RestClient::Unauthorized
        @app.destroy and return
      end

      if @options["all"] || @options[:all]
        create_activities_from moves.daily_activities pastDays: PAST_DAYS
      else
        # checks for earlier updates, but at least always updates today's AND yesterday's activity measurements
        if @app.user.last_activity_measurement.try(:timestamp).present?
          updated_since = ((Date.current - @app.user.last_activity_measurement.try(:timestamp).to_date).round + 2)
        else 
          updated_since = PAST_DAYS
        end
        create_activities_from moves.daily_activities pastDays: updated_since
      end

      if @measurements.present?
        PusherWorker.perform_async "private-nuwe-#{@app.user.id}", "health-data-updated", {provider: @app.provider, user: @app.user.to_json}
      end
    rescue RestClient::BadRequest => e
      Rails.logger.debug "Moves BadRequest error #{e}"
    end

    private

    def create_activities_from(days)
      days.each do |day|
        date = Date.strptime(day["date"], "%Y%m%d")
        Measurement::Activity.where(source: "moves", user: @app.user, date: date).destroy_all
        # Pulls last_update from the very last activity in the request
        segments = day['segments']
        if day['segments'] == nil
          timestamp = date
        else
          lastupdate = segments[-1]
          timestamp = lastupdate['lastUpdate']
        end
        if day['summary'].present?
          day["summary"].each do |activity|
            @measurements << Measurement::Activity.create!({
              user:       @app.user,
              date:       date,
              timestamp:  timestamp,
              start_time: date,
              end_time:   date,
              type:       activity["activity"],
              source:     "moves",
              duration:   activity["duration"],
              distance:   activity["distance"],
              steps:      activity["steps"],
              calories:   activity["calories"]
            })
          end
        end
      end
    end

  end

end
