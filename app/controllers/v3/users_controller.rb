# Create users by posting a JSON dictionary to this controller.
class V3::UsersController < V3::BaseController

  skip_after_filter :create_stat

  def create
    result = SignUp.call(user_params.merge(root_url: root_url, headers: request.headers["HTTP_AUTHORIZATION"]))

    if result.success?
      render json: result.user, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :facebook_id)
  end
end
