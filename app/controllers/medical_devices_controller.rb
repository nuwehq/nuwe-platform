class MedicalDevicesController < ApplicationController
  before_action :find_application

  def new
    @medical_device = @application.medical_devices.new
  end

  def create
    @medical_device = @application.medical_devices.new medical_device_params
    if @medical_device.save
      redirect_to oauth_application_path(@application), notice: "The device has been added."
    else
      render 'new', notice: "Sorry, please try again."
    end
  end

  def edit
    @medical_device = @application.medical_devices.find params[:id]
  end

  def update
    @medical_device = @application.medical_devices.find params[:id]
    if @medical_device.update medical_device_params
      redirect_to oauth_application_path(@application), notice: "The device has been updated."
    else
      render 'edit'
    end
  end

  def destroy
    @medical_device = MedicalDevice.find params[:id]
    if @medical_device.destroy
      redirect_to oauth_application_path(@application), notice: "The device has been deleted."
    end
  end

  private

  def medical_device_params
    params.require(:medical_device).permit(:name, :enabled)
  end
end
