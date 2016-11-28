class V3::MedicalDevicesController < V3::BaseController

  before_action :authenticate_application
  before_action :find_application
  skip_after_filter :create_stat

  def index
    medical_devices = @application.medical_devices.all
    paginate json: medical_devices
  end

  private

  def find_application
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
  end

  def device_result_params
    params.require(:device_result).permit!
  end
end
