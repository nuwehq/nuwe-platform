# Allow users to reset their password.
# They do not have to be logged-in for this to work.
class V3::ResetPasswordsController < V3::BaseController

  skip_after_filter :create_stat

  def create
    @user = User.find_by_email! params[:user][:email]
    UserMailer.reset_password(@user, reset_password_url(@user, @user.token)).deliver_later
    render json: {reset_password: {message: "Email was sent with instructions to reset password."}}
  end

end
