class RemoveForeignKeyDeviceFilesMedicalDevices < ActiveRecord::Migration
  def change
    remove_foreign_key :device_files, name: "fk_rails_2be64460d2"
  end
end
