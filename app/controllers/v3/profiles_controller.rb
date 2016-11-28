# Update an existing user's profile.
# Requires a valid API token.
class V3::ProfilesController < V3::BaseController

  before_action :doorkeeper_authorize!

  def show
    render json: current_user
  end

  def update
    result = ProfileUpdate.call(user: current_user, profile_params: profile_params, data: params[:profile][:data])
    if result.success?
      render json: result.user, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def destroy
    current_user.profile.destroy
    render json: current_user, status: 200
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :sex, :birth_date, :activity, :weight, :height, :bpm, :blood_pressure, :units, :use_health_data, :avatar, :time_zone)
  end

end
