class DataQueryInteractor::FindFirst
  include Interactor

  delegate :medical_device, to: :context

  def call
    return unless context.find_first.present?
    if medical_device.device_results.present?
      context.search_results << medical_device.device_results.first
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: "Medical device has no device results"
    end
  end


end
