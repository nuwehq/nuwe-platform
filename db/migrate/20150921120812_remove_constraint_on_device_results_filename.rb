class RemoveConstraintOnDeviceResultsFilename < ActiveRecord::Migration
  def change
    change_column :device_results, :filename, :string, :null => true
  end
end
