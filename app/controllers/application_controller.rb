class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize
    if params[:token]
      @current_user = Token.find(params[:token]).user
      session[:user_id] = @current_user.id
    end

    unless current_user
      redirect_to unauthorized_path
    end
  end

  def user_signed_in?
    !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end

  def find_application
    @application = Doorkeeper::Application.find params[:application_id]
  end

  helper_method :current_user
end
