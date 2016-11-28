# Authenticate all admin requests. Non-token requests are not allowed
# and the user must have the 'admin' role.
class V1::Admin::BaseController < V1::BaseController

  before_filter :authenticate

  private

  def admin?
    logged_in? && @current_user.roles.include?('admin')
  end

  def authenticate
    unless admin?
      render json: {error: {message: "Authorization failed"}}, status: :unauthorized
    end
  end
end
