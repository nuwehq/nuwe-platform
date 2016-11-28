# Upload a CloudCode JavaScript file.
#
# This needs to update and redeploy the Docker application.
class CloudCodesController < ApplicationController
  before_action :find_application

  def create

    @application.update application_params
    ParseServiceWorker.new(@application).update_env_vars
    if request.xhr?
      render status: 200, nothing: true
    else
      redirect_to oauth_application_path(@application), notice: "Cloud Code uploaded."
    end
  end

  private

  def application_params
    params.require(:doorkeeper_application).permit(:cloud_code_file)
  end
end
