class SessionsController < ApplicationController

  def new
    session[:return_to] = params[:return_to]
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:return_to] || root_url, notice: "Logged in!"
      session.delete(:return_to)
    else
      flash.now.alert = "Invalid password or email"
      render "new"
    end
  end

end
