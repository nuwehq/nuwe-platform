class V3::DevicesController < V3::BaseController

  before_action :doorkeeper_authorize!

  def create
    # A User can "steal" a token from a different user, if this user is using the other
    # user's device to log in to our service. The most recent user to use this token
    # must be stored in our database, because this is where push notifications are sent.
    @device = Device.find_or_initialize_by token: device_params[:token]
    @device.user = current_user

    if @device.save
      render json: current_user.devices
    else
      render json: {error: {message: @device.errors.full_messages}}, status: :bad_request
    end
  end

  def index
    render json: current_user.devices
  end

  private

  def device_params
    params.require(:device).permit(:token)
  end

end
