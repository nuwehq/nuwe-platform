require 'interactor'

module DeviceResultsInteractor
  class UpdateColumns
    include Interactor

    def call
      medical_device = context.medical_device
      if context.columns.present?
        medical_device.column_values.destroy_all
        context.columns.each do |column|
          value = medical_device.column_values.new
          column.each do |k,v|
            value[k] = v
          end
          value.save!
        end
      end
    end
  end
end
