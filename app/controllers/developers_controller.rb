class DevelopersController < ApplicationController
  respond_to :html, :js, :json

  def new
    @user = User.new
  end

  def create
    result = DeveloperSignup.call params: user_params

    if result.success?
      session[:user_id] = result.user.id
      redirect_to oauth_applications_path, notice: "Welcome to Nuwe. Check out the Sample app we created to get you started!"
    else
      respond_with result.user
    end
  end


  def update
    if current_user.update user_params
      current_user.roles << 'developer'
      current_user.save
      redirect_to oauth_applications_path, notice: "Your Nuwe Developer Platform information has been updated."
    else
      render oauth_applications_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
