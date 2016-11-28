class CreateMedicalDevices < ActiveRecord::Migration
  def change
    create_table :medical_devices do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.boolean :enabled, default: false
      t.references :application, index: true, null: false
      t.timestamps
    end
  end
end
