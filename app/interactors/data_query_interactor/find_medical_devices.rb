class DataQueryInteractor::FindMedicalDevices
  include Interactor

  delegate :medical_device, to: :context

  def call
    return unless context.find_medical_devices.present?
    medical_devices = context.query[:medical_devices]
    date_range = context.query[:dates]
    from = date_range[:from]
    to = date_range[:to]

    medical_devices.each do |device|
      medical_device = MedicalDevice.find_by_token(device[:device])
      context.search_results << medical_device.device_results.where(date: from..to)
    end

    if context.search_results.empty?
      context.status = :bad_request
      context.fail! message: "These devices have no results"
    else
      context.status = :ok
    end
  end


end
