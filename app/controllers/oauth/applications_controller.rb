module Oauth
  class ApplicationsController < Doorkeeper::ApplicationsController
    respond_to :html, :js
    before_filter :user_logged_in
    before_filter :apps_over_limit, only: :index

    def index
      @applications = current_user.oauth_applications + current_user.collaborated_applications
    end

    def show
      @applications = current_user.oauth_applications + current_user.collaborated_applications
      @application = Doorkeeper::Application.find(params[:id])
      @collaborations = @application.collaborations
      unless current_user == @application.owner || @application.users.include?(current_user)
        redirect_to unauthorized_path
      end
      @medical_devices = @application.medical_devices
      @cloud_code_file = Paperclip.io_adapters.for(@application.cloud_code_file).read
    end

    def new
      @applications = current_user.oauth_applications
      super
    end

    def first_app
      @first_app = true
      @applications = current_user.oauth_applications
      @application = @applications.first
      render 'new'
    end

    def create
      result = DoorkeeperInteractor::DoorkeeperApplication.call(application_params: application_params, user: current_user)
      respond_to do |format|
        if result.success?
          response = []
          response << result.application.id
          result.application.capabilities.each do |cap|
            response << cap.service_id
          end
          format.html { redirect_to oauth_applications_path(result.id), notice: "You logged in successfully" }
          format.js { render plain: response, status: :ok }
          # Todo: change the JS for app creation to accept the newly created capabilities
          # format.js { render json: result.application.capabilities, status: result.status }
          # DONE
        else
          format.html { redirect_to root_url, alert: "Something went wrong!" }
          format.js { render json: result.message, status: result.status }
        end
      end
    end

    def update
      @application = Doorkeeper::Application.find(params[:id])
      update_app = @application.update_attributes(application_params)

      response = []
      response << @application.id
      @application.capabilities.each do |cap|
        response << cap.service_id
      end


      respond_to do |format|
        format.html { redirect_to oauth_applications_path(@application.id), notice: "You have updated the application" }
        if remotipart_submitted?
          format.js { render plain: @application.icon.url(:small), status: :ok}
        else
          if update_app
            format.js { render plain: response, status: :ok}
          else
            format.js { render plain: response, status: :bad_request }
          end
        end
      end
    end

    def destroy
      @application = current_user.oauth_applications.find(params[:id])
      if @application.destroy
        redirect_to oauth_applications_url, notice: "Application deleted."
      end
    end


    private

    def user_logged_in
      if !!session[:user_id] == false
        redirect_to root_url
      end
    end

    def current_user
      @current_user ||= User.find_by_id session[:user_id]
    end
    helper_method :current_user

    def application_params
      params.require(:doorkeeper_application).permit(:name, :redirect_uri, :description, :enabled, :platform, :icon, :user_limit)
    end

    def apps_over_limit
      @apps_over_limit = current_user.oauth_applications.find_all { |application| application.user_limit? || application.request_limit? }
    end
  end
end
