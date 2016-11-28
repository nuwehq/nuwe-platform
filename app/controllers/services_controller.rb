class ServicesController < ApplicationController

  before_action :require_admin, only: [:new, :create, :edit, :update]
  before_action :find_application, only: [:toggle]

  def new
    @service = Service.new
  end

  def create
    @service = Service.new service_params
    if @service.save
      redirect_to oauth_applications_path, notice: "This service has been added."
    else
      render 'new'
    end
  end

  def edit
    @service = Service.find params[:id]
    session[:return_to] = params[:app]
  end

  def update
    @service = Service.find params[:id]
    if @service.update service_params
      if session[:return_to]
        redirect_to oauth_application_path(Doorkeeper::Application.find(session[:return_to]))+"#services", notice: "#{@service.name} has been updated."
      else
        redirect_to oauth_applications_path, notice: "#{@service.name} has been updated."
      end
    else
      render 'edit'
    end
  end

  def toggle
    @service = Service.find params[:id]

    if (@capability = @application.capabilities.where(service: @service).first)
      @capability.destroy
    else
      @capability = @application.capabilities.create! service: @service
      if @service.lib_name == "parse_core"
        result = ParseInteractor::Setup.call application: @application
        if result.success?
          flash[:error] = "Please wait until your Parse Server is set up. This will take around 15 minutes."
        else
          flash[:error] = result.message
        end
      end
    end
    render nothing: true
  end

  private

  def require_admin
    redirect_to unauthorized_path, notice: "You are not authorized to perform that action" unless current_user.roles.include?("admin")
  end

  def service_params
    params.require(:service).permit(:name, :description, :needs_remote_credentials, :coming_soon, :icon, :service_category_id)
  end

end
