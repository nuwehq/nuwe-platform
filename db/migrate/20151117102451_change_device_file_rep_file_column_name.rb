class ChangeDeviceFileRepFileColumnName < ActiveRecord::Migration
  def change
    add_column :device_files, :upload_action, :string
    remove_column :device_files, :repfile, :boolean
  end
end
