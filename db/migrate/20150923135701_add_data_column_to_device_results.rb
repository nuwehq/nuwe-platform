class AddDataColumnToDeviceResults < ActiveRecord::Migration
  def change
    DeviceResult.destroy_all
    add_column :device_results, :data, :string, :null => false
    remove_column :device_results, :values, :string
  end
end
