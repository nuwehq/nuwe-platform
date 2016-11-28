require 'interactor'

module UserInteractor
  # Create database records that every user should have by default.
  class Defaults

    include Interactor

    def call
      context.user.tokens.create! scope: "api"
      context.user.preferences.create! name: "units", value: "metric"
      context.user.preferences.create! name: "use_health_data", value: "true"
    end

  end
end
