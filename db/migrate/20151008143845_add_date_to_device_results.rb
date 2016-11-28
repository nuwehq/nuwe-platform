class AddDateToDeviceResults < ActiveRecord::Migration
  def change
    add_column :device_results, :date, :date

    DeviceResult.all.each do |result|
      result.date = result.created_at
      result.save!
    end

    change_column :device_results, :date, :date, :null => false
  end
end
