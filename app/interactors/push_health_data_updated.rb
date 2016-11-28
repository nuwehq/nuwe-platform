require 'interactor'

# Push the +health-data-updated+ event so the client can progress into the next state.
class PushHealthDataUpdated

  include Interactor

  def call
    PusherWorker.perform_async "private-nuwe-#{context.user.id}", "health-data-updated", {provider: "nuwe", user: context.user.to_json}
  end

end
