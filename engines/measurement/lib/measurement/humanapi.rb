require 'httparty'

module Measurement

  # Requests measurements via the HumanAPI API.
  class Humanapi

    include HTTParty

    base_uri 'https://api.humanapi.co'

    def initialize(app)
      @app = app
      @measurements = []
    end

    # Synchronize the user's health data.
    def self.synchronize(app, options={})
      humanapi = new(app)

      # When authorization fails, remove the app since it's become useless.
      app.destroy and return if humanapi.invalid_token?

      if options[:all] || options["all"]
        # This will fetch all health data we can find.

        humanapi.create_bmis_from "/v1/human/bmi/readings"
        humanapi.create_weights_from "/v1/human/weight/readings"
        humanapi.create_heights_from "/v1/human/height/readings"
        humanapi.create_activities_from "/v1/human/activities"

      else
        # This will only fetch records newer than the most recent record we have.

        updated_since = app.user.last_bmi_measurement.try(:updated_at) || 1.month.ago
        humanapi.create_bmis_from "/v1/human/bmi/readings?updated_since=#{updated_since.strftime("%Y%m%dT%H%M%SZ")}"

        updated_since = app.user.last_weight_measurement.try(:updated_at) || 1.month.ago
        humanapi.create_weights_from "/v1/human/weight/readings?updated_since=#{updated_since.strftime("%Y%m%dT%H%M%SZ")}"

        updated_since = app.user.last_height_measurement.try(:updated_at) || 1.month.ago
        humanapi.create_heights_from "/v1/human/height/readings?updated_since=#{updated_since.strftime("%Y%m%dT%H%M%SZ")}"

        updated_since = app.user.last_activity_measurement.try(:updated_at) || 1.month.ago
        humanapi.create_activities_from "/v1/human/activities?updated_since=#{updated_since.strftime("%Y%m%dT%H%M%SZ")}"

      end

      if @measurements.present?
        PusherWorker.perform_async "private-nuwe-#{@app.user.id}", "health-data-updated", {provider: @app.provider, user: @app.user.to_json}
      end
    end

    # Will return true if the stored credentials apparently have been revoked.
    def invalid_token?
      response = self.class.get "/v1/human/profile", headers
      response.code == 401 && response["error"] == "invalid_token"
    end

    # Response is an array of measurements.
    # http://docs.humanapi.co/docs/bmi
    def create_bmis_from(url)
      response = self.class.get url, headers

      if response.is_a?(Array)
        response.each do |measurement|
          @measurements << Measurement::Bmi.create!({
            user:       @app.user,
            date:       measurement["timestamp"],
            timestamp:  measurement["timestamp"],
            value:      measurement["value"],
            unit:       measurement["unit"],
            source:     measurement["source"],
            created_at: measurement["createdAt"],
            updated_at: measurement["updatedAt"]
          })
        end
      else
        warn "Unable to create BMI measurement from #{response}"
      end
    end

    def create_weights_from(url)
      response = self.class.get url, headers

      if response.is_a?(Array)
        response.each do |measurement|
          @measurements << Measurement::Weight.create!({
            user:       @app.user,
            date:       measurement["timestamp"],
            timestamp:  measurement["timestamp"],
            value:      measurement["value"],
            unit:       measurement["unit"],
            source:     measurement["source"],
            created_at: measurement["createdAt"],
            updated_at: measurement["updatedAt"]
          })
        end

        if (links = response.headers["Link"])
          links.split(",").each do |link|
            url, rel = link.split("; ")

            if rel == 'rel="next"'
              create_weights_from url[1..-2]
            end
          end
        end
      else
        warn "Unable to create weight measurement from #{response}"
      end
    end

    def create_heights_from(url)
      response = self.class.get url, headers

      if response.is_a?(Array)
        response.each do |measurement|
          @measurements << Measurement::Height.create!({
            user:       @app.user,
            date:       measurement["timestamp"],
            timestamp:  measurement["timestamp"],
            value:      measurement["value"],
            unit:       measurement["unit"],
            source:     measurement["source"],
            created_at: measurement["createdAt"],
            updated_at: measurement["updatedAt"]
          })
        end
      else
        warn "Unable to create height measurement from #{response}"
      end
    end

    def create_activities_from(url)
      response = self.class.get url, headers

      if response.is_a?(Array)
        response.each do |measurement|
          @measurements << Measurement::Activity.create!({
            user:       @app.user,
            date:       measurement["startTime"],
            timestamp:  measurement["startTime"],
            start_time: measurement["startTime"],
            end_time:   measurement["endTime"],
            type:       measurement["type"],
            source:     measurement["source"],
            duration:   measurement["duration"],
            distance:   measurement["distance"],
            steps:      measurement["steps"],
            calories:   measurement["calories"],
            created_at: measurement["createdAt"],
            updated_at: measurement["updatedAt"]
          })
        end
      else
        warn "Unable to create activity measurement from #{response}"
      end
    end

    private

    def headers
      {
        headers: {"Authorization" => "Bearer #{@app.credentials['accessToken']}"}
      }
    end

  end

end
