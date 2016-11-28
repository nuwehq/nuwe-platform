require 'interactor'

module MedicalDeviceColumnsInteractor
  class UpdateColumn
    include Interactor

    def call
      column_value = context.column_value
      if column_value.update_attributes context.column_value_params
        context.column_value = column_value
      else
        context.status = :bad_request
        context.fail! message: column_value.errors.full_messages
      end
    end

  end
end
