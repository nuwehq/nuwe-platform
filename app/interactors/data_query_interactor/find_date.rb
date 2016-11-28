require 'date'
class DataQueryInteractor::FindDate
  include Interactor
  delegate :medical_device, to: :context

  def call
    return unless context.find_date.present?
    if medical_device.device_results.present?
      context.query.each do |k,v|
        date = Date.strptime(v, '%Y-%m-%d')
        context.search_results = medical_device.device_results.where(date: date)
      end
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: "Medical device has no device results"
    end
  end


end
