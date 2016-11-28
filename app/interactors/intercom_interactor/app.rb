module IntercomInteractor
  class App
    include Interactor

    def call
      IntercomWorker.perform_async(context.user.email, {
        connected_apps: connected_apps
      })
    end

    private

    # Array of strings with all connected apps by this user.
    # e.g. ["moves", "withings"]
    def connected_apps
      context.user.apps.map(&:provider).join(" ")
    end

  end
end
