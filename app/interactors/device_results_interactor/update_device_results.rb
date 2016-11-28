class DeviceResultsInteractor::UpdateDeviceResults
  include Interactor

  before do
    context.columns = context.device_result_params.delete(:columns)
  end

  def call
    device_result = context.device_result
    if device_result.update context.device_result_params
      context.device_result = device_result
    else
      context.status = :bad_request
      context.fail! message: device_result.errors.full_messages
    end
  end


end
