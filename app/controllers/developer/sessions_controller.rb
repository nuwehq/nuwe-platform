class Developer::SessionsController < ApplicationController

  def new
  end

  def create
    if params[:email]
      user = User.find_by_email(params[:email])
      respond_to do |format|
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          if user.roles.include?('developer')
            format.html { redirect_to oauth_applications_path, notice: "You logged in successfully" }
            format.js {render plain: oauth_applications_path, status: :ok }
          else
            format.html { redirect_to no_developer_path, notice: "You logged in successfully" }
            format.js {render plain: no_developer_path, status: :ok }
          end
        else
          format.html { redirect_to login_url, alert: "Wrong login or password!" }
          format.js { render plain: "Wrong login or password", status: :unprocessable_entity }
        end
      end
    elsif request.env["omniauth.auth"]
      user = UserFromOmniauth.new(request.env["omniauth.auth"]).user
      respond_to do |format|
        session[:user_id] = user.id
        if user.roles.include?('developer')
          format.html { redirect_to oauth_applications_path, notice: "You logged in successfully" }
          format.js {render plain: oauth_applications_path, status: :ok }
        else
          format.html { redirect_to no_developer_path, notice: "You logged in successfully" }
          format.js {render plain: no_developer_path, status: :ok }
        end
      end
    end
  end

  def update_first_app_name
    respond_to do |format|
      if params[:appname]
        app = current_user.oauth_applications.first
        app.name = params[:appname]
        if app.save
          format.html { redirect_to oauth_applications_path, notice: "You logged in successfully" }
          format.js {render plain: oauth_applications_path, status: :ok }
        else
          format.html { redirect_to root_url, alert: "Something went wrong!" }
          format.js { render plain: "Something went wrong", status: :bad_request }
        end
      else
        format.html { redirect_to root_url, alert: "Something went wrong!" }
        format.js { render plain: "Something went wrong", status: :bad_request }
      end
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

  private

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user

end
