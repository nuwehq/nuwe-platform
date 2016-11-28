class UsersController < ApplicationController

  before_action :find_application, only: [:measurement]

  def show
    @user = current_user
    @profile = current_user.profile
    @technologies = Profile.all.flat_map(&:technologies).uniq
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if User.exists?(email: user_params[:email])
      redirect_to new_session_path, notice: "You already have an account"
    elsif @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      flash[:error] = "Error saving user. Please try again."
      render "new"
    end
  end

  def confirm
    @user = User.find(params[:user_id])
    @user.confirm_email!(params[:token])
  end

  def update
    if current_user.update user_params
      redirect_to user_path, notice: "Your password has been changed."
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
