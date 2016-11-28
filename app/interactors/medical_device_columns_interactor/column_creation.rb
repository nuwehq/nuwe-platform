require 'interactor'

module MedicalDeviceColumnsInteractor
  class ColumnCreation
    include Interactor

    before do
      context.column_values = []
    end

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
          context.column_values << value
        end
      end
      context.status = :created
    rescue => error
      context.status = :bad_request
      context.fail! message: error.message
    end
  end
end
