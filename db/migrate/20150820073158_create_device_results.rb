class CreateDeviceResults < ActiveRecord::Migration
  def change
    create_table :device_results do |t|
      t.string :filename, null: false
      t.hstore :values, default: {}, null: false
      t.references :medical_device, index: true, null: false
      t.timestamps
    end
  end
end
