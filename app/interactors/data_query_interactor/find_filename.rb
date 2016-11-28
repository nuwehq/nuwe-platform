class DataQueryInteractor::FindFilename
  include Interactor
  delegate :medical_device, to: :context

  def call
    return unless context.find_filename.present?
    if medical_device.device_results.present?
      context.query.each do |k,v|
        context.search_results = medical_device.device_results.where(filename: v)
      end
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: "Medical device has no device results"
    end
  end


end
