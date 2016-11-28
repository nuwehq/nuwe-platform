class CapabilitiesController < ApplicationController

  before_action :find_service, :find_application

  def edit
    @capability = @service.capabilities.where(application_id: @application.id).first
    template = "edit"
    template = "not_active" if @capability.nil?
    template = "not_editable" unless @service.needs_remote_credentials?

    render template, layout: !request.xhr?
  end

  def update
    @capability = @service.capabilities.where(application_id: @application.id).first

    if @capability.update(capability_params)
      redirect_to oauth_application_path(@application), notice: "Your credentials have been added!"
    else
      render 'edit'
    end
  end


  private

    def find_service
      @service = Service.find(params[:service_id])
    end

    def find_application
      @application = current_user.oauth_applications.find params[:application_id]
    end

    def capability_params
      params.require(:capability).permit(:remote_application_key, :remote_application_secret)
    end
end
