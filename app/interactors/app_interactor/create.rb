# Link an OAuth application to an existing user using Omniauth.
module AppInteractor
  class Create
    include Interactor

    def call
      new_app = context.user.apps.find_or_initialize_by provider: context.provider

      if new_app.update context.to_h.slice(:uid, :info, :credentials)
        context.app = new_app
        PusherWorker.perform_async "private-nuwe-#{context.user.id}", "app-connected", {provider: context.provider}
        HealthDataWorker.perform_async(new_app.id, all: true)
      else
        context.fail! message: "Unable to save the App with provider #{context.provider}"
      end
    end

  end
end
