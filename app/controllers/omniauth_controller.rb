# Used for the Omniauth callbacks, i.e. when connecting apps & devices.
class OmniauthController < ApplicationController

  def create
    result = AppInteractor::Connect.call(auth_hash)

    # since Moves is an external app, using nuweapps:// will switch back to Nuwe app.
    if params[:provider] == "moves"
      redirect_to "nuweapp://apps?provider=#{params[:provider]}"
    else
      render html: "App is connected"
    end
  end

  def failure
    @strategy = params[:strategy]
  end

  protected

  # Merge the auth_hash (with user information) with params (which contains the state).
  # The +state+ param should contain the user's API token.
  def auth_hash
    params.permit(:state).merge(request.env['omniauth.auth']).merge(request.env['omniauth.params'])
  end

end
