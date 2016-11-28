class ChangeColumnValueReferenceToMedicalDeviceFromDeviceResult < ActiveRecord::Migration
  def change
    add_reference :column_values, :medical_device
    execute "update column_values set medical_device_id = (select medical_device_id from device_results where id = device_result_id)"
    remove_reference :column_values, :device_result
  end
end
