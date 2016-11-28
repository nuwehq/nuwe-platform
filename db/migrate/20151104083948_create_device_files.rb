class CreateDeviceFiles < ActiveRecord::Migration
  def change
    create_table :device_files do |t|
      t.string :filename
      t.boolean :repfile, default: false
      t.references :medical_device, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
