# Allow our users to Connect with HumanAPI.
class HumanapiController < ApplicationController

  layout "clean"
  before_filter :authorize

  # Human API Connect
  def create
    if current_user.apps.where(provider: "humanapi").empty?
      FinalizeHumanApi.perform_async(params, current_user.id)
    end

    PusherWorker.perform_async "private-nuwe-#{current_user.id}", "app-connected", {provider: "humanapi"}
    render nothing: true
  end

end
