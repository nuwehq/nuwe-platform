class DeviceResultsController < ApplicationController

  respond_to :html, :js, :json

  def index
    @medical_device = MedicalDevice.find params[:medical_device_id]
    @device_results = @medical_device.device_results

    if request.xhr?
      render json: @device_results
    end

  end

end
