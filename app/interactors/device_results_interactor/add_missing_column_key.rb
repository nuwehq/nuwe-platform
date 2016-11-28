class DeviceResultsInteractor::AddMissingColumnKey
  include Interactor

  delegate :medical_device, to: :context

  def call
    context.device_results.each do |device_result|

      medical_device.column_values.each do |column|
        unless device_result.data.has_key?(column.field_name)
          hash = {column.field_name => nil}
          device_result.data.merge!(hash)
        end
      end
    end
  end

end
