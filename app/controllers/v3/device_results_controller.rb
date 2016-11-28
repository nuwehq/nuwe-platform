class V3::DeviceResultsController < V3::BaseController

  before_filter :find_medical_device

  skip_after_filter :create_stat

  def query
    result = DataQueryInteractor::Setup.call query: params[:query], medical_device: @medical_device, medical_devices: params[:query][:medical_devices]
    if result.success?
      render json: result.search_results, status: result.status
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end

  def upload
    result = MedicalDeviceUploader::SetUp.call file: device_result_params[:file], filename: device_result_params[:filename], upload_action: device_result_params[:upload_action], medical_device: @medical_device
    if result.success?
      render json: result.upload, root: "upload", status: result.status
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end

  def index
    device_results = @medical_device.device_results
    paginate json: device_results, meta: {columns: @medical_device.column_values}
  end

  def create
    result = DeviceResultsInteractor::ResultsSetUp.call data: device_result_params[:data], medical_device: @medical_device, columns: device_result_params[:columns], repfile: device_result_params[:repfile], filename: device_result_params[:filename]
    if result.success?
      render json: result.device_results, status: result.status
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end

  def update
    result = DeviceResultsInteractor::Update.call device_result: DeviceResult.find(params[:id]), device_result_params: device_result_params, medical_device: @medical_device, columns: device_result_params[:columns]
    if result.success?
      render json: result.device_result, status: result.status
    else
      render json:{error: {message: result.message}, status: result.status}
    end
  end


  def destroy
    @device_result = DeviceResult.find(params[:id])
    if @device_result.destroy
      render json: {notice: {message: "Device Result deleted.", device_result:@device_result}}
    else
      render json: {error: {message: @device_result.errors.full_messages}}, status: :bad_request
    end
  end

  private

  def find_medical_device
    @medical_device = MedicalDevice.find_by_token! params[:medical_device_id]
  end

  def device_result_params
    params.require(:device_result).permit!
  end
end
