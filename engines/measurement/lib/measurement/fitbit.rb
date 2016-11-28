require 'fitgem'

module Measurement

  class Fitbit

    PAST_DAYS = 60

    def initialize(app, options={})
      @app = app
      @options = options
      @measurements = []
    end

    def synchronize
      consumer_key = ENV['FITBIT_KEY']
      consumer_secret = ENV['FITBIT_SECRET']

      client = Fitgem::Client.new(({
              :consumer_key => consumer_key,
              :consumer_secret => consumer_secret,
              :token => @app.credentials['token'],
              :secret => @app.credentials['secret'], 
              :user_id => @app.uid
            }))
      access_token = client.reconnect(@app.credentials['token'], @app.credentials['secret'])
      
      start_date = Date.current
      end_date = PAST_DAYS.days.ago.to_date

      if @options["all"] || @options[:all]
        update_profile_with client.user_info
        create_activities_from client.activity_on_date_range('calories', start_date, end_date)
      else
        update_profile_with client.user_info
        updated_since = @app.user.last_activity_measurement.try(:timestamp) || PAST_DAYS.days.ago
        create_activities_from client.activity_on_date_range('calories', start_date, updated_since)
      end
    end

    def update_profile_with(response)
      if @app.user.height.nil?
        Measurement::Height.create!({
            user:       @app.user,
            date:       Date.current,
            timestamp:  Time.current,
            value:      (response['user']['height'] * 25.4).round,
            unit:       'mm',
            source:     'fitbit'
          })
      end
      if @app.user.weight.nil?
        Measurement::Weight.create!({
            user:       @app.user,
            date:       Date.current,
            timestamp:  Time.current,
            value:      (response['user']['weight'] * 453.596).round,
            unit:       'grams',
            source:     'fitbit'
          })
      end
      if @app.user.sex.nil?
        if response['user']['gender'] == "FEMALE"
          gender = 'F'
        elsif response['user']['gender'] == "MALE"
          gender = 'M'
        end
        @app.user.profile.update!({
          sex:           gender
          })
      end
      if @app.user.birth_date.nil?
        @app.user.profile.update!({
          birth_date:    response['user']['dateOfBirth']
          })
      end
    end

    def create_activities_from(response)
      if response['activities-calories'].present?
        response['activities-calories'].each do |day|
          date = day['dateTime'].to_date
          Measurement::Activity.where(source: "fitbit", user: @app.user, date: date).destroy_all

          @measurements << Measurement::Activity.create!({
            user:       @app.user,
            date:       date,
            timestamp:  date,
            type:       'calories',
            source:     'fitbit',
            start_time: date,
            end_time:   date,
            calories:   day['value']
          })
        end
      end
    end

  end
end