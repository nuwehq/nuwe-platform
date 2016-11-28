require 'interactor'

module DeviceResultsInteractor
  class CreateColumns
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
      else
        context.device_result.data.each do |k,v|
          if medical_device.column_values.where(field_name: k).empty?
            column = medical_device.column_values.new
            column.field_name = k
            column.read_only = false
            if v.match(/^[-+]?\d+$/)
              column.type = "integer"
              column.editor = "integer"
            elsif v.match(/\d+[,.]\d+/)
              column.type = "float"
              column.editor = "float"
            else
              column.type = "string"
              column.editor = "text"
            end
            if k == "created_at"
              column.editor = "datetimePicker"
              column.type = "datetime"
              column.read_only = true
            elsif k == "updated_at"
              column.editor = "datetimePicker"
              column.type = "datetime"
              column.read_only = true
            elsif k == "date"
              column.editor = "datetimePicker"
              column.type = "datetime"
              column.read_only = true
            elsif k == "id"
              column.editor = ""
              column.read_only = true
            end
            column.save!
          end
        end
      end
    end
  end
end
