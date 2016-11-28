# Update an existing user's password.
# Requires a valid API token and the current password.
class V3::UpdatePasswordsController < V3::BaseController

  before_action :doorkeeper_authorize!, :require_current_password

  def update
    current_user.password = user_params[:new_password]
    current_user.password_confirmation = user_params[:new_password]

    if current_user.save
      render json: current_user
    else
      render json: {error: {message: current_user.errors.full_messages}}, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:new_password)
  end

  def require_current_password
    unless current_user.authenticate params[:user][:current_password]
      render json: {error: {message: ["Current password is not valid"]}}, status: :bad_request
    end
  end
  
end
