# Used when the user has requested a password reset.
class PasswordsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_email params[:email]
    if @user
      UserMailer.reset_password(@user, reset_password_url(@user, @user.token)).deliver_later
      redirect_to root_url, notice: "Email was sent with instructions to reset password."
    else
      redirect_to forgot_password_url, alert: "Email address not found."
    end
  end

  def edit
    @user = User.find params[:id]

    if @user.verify_token! params[:token]
      session[:user_id] = @user.id
    else
      render "invalid_token"
    end
  end

end
