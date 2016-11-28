require 'date'
class DataQueryInteractor::FindDateRange
  include Interactor
  delegate :medical_device, to: :context

  def call
    return unless context.find_date_range.present?
    if medical_device.device_results.present?
      context.query.each do |k,v|
        if v.has_key?("from")
          context.search_results = medical_device.device_results.where(date: v["from"]..v["to"])
        end
      end
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: "Medical device has no device results"
    end
  end


end
