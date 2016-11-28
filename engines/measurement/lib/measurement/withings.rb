require 'rubygems'
require 'withings'

module Measurement

  class Withings

    PAST_DAYS = 60

    def initialize(app, options={})
      @app = app
      @options = options
      @measurements = []
    end

    def synchronize
      ::Withings.consumer_secret = ENV['WITHINGS_SECRET']
      ::Withings.consumer_key = ENV['WITHINGS_KEY']

      begin
        withings_user
      rescue ::Withings::ApiError
        @app.destroy and return
        return
      end


      if @options["all"] || @options[:all]
        create_measurements_from withings_user.measurement_groups(:start_at => (DateTime.yesterday - PAST_DAYS.days).to_time.to_i, :end_at => DateTime.current.to_time.to_i, :devtype => 0)
        create_activities_from withings_user.get_activities(:startdateymd => PAST_DAYS.days.ago.strftime("%Y-%m-%d"), :enddateymd => Date.current.strftime("%Y-%m-%d"))
      else
        updated_since = @app.user.last_weight_measurement.try(:timestamp) || @app.user.last_height_measurement.try(:timestamp) || PAST_DAYS.days.ago
        create_measurements_from withings_user.measurement_groups(:last_updated_at => updated_since.to_time.to_i, :devtype => 0)
      end

      if @measurements.present?
        PusherWorker.perform_async "private-nuwe-#{@app.user.id}", "health-data-updated", {provider: @app.provider, user: @app.user.to_json}
      end
    end

    private

    def withings_user
      ::Withings::User.authenticate(@app.uid, @app.credentials['token'], @app.credentials['secret'])
    end


    def create_measurements_from(response)
      # The Simplificator-Withings Gem stringifies the response, check the gem:
      # https://github.com/simplificator/simplificator-withings/blob/master/lib/withings/measurement_group.rb
      response.each do |day|
        date = day.taken_at.strftime("%Y%m%d")
        if day.weight.present?
          Measurement::Weight.where(source: "withings", user: @app.user, date: date).destroy_all

          @measurements << Measurement::Weight.create!({
            user:       @app.user,
            date:       date,
            timestamp:  date,
            value:      (day.weight * 1000),
            source:     "withings",
            unit:       "grams"            
          })
        end
        if day.size.present?
          Measurement::Height.where(source: "withings", user: @app.user, date: date).destroy_all

          @measurements << Measurement::Height.create!({
            user:       @app.user,
            date:       date,
            timestamp:  date,
            value:      (day.size * 1000),
            source:     "withings",
            unit:       "grams" 
            })
        end
      end
    end

    def create_activities_from(response)
      response['activities'].each do |day|
        if day['calories'] > 0
          date = day['date'].to_date
          Measurement::Activity.where(source: "withings", user: @app.user, date: date).destroy_all
          @measurements << Measurement::Activity.create!({
            user:       @app.user,
            date:       date,
            timestamp:  date,
            type:       'calories',
            source:     'withings',
            start_time: date,
            end_time:   date,
            calories:   day['calories']
          })
        end
      end
    end


  end
end