# Authenticate users with email and password.
# For a successful auth, a token is returned. The token must be used to access the API.
class V3::AuthController < V3::BaseController

  before_action :doorkeeper_authorize!, only: [:pusher]
  skip_after_filter :create_stat, except: [:pusher]

  def create
    result = SignIn.call(session_params)

    if result.success?
      render json: result.user, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  # Return an authentication string for private Pusher channels.
  #
  # People are only allowed to subscribe to their own channel name: private-nuwe-ID.
  #
  # http://pusher.com/docs/authenticating_users
  def pusher
    channel_name = params[:channel_name]

    if (match = /\Aprivate-nuwe-(\d+)\z/.match(channel_name))
      if current_user.id == match[1].to_i
        render json: Pusher[channel_name].authenticate(params[:socket_id])
      else
        render json: {error: {message: ["You can only subscribe to your own channel 'private-nuwe-#{current_user.id}'"]}}, status: :unauthorized
      end
    else
      render json: {error: {message: ["Channel #{channel_name} not found"]}}, status: :not_found
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
