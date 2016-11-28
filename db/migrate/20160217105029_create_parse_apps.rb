class CreateParseApps < ActiveRecord::Migration
  def change
    create_table :parse_apps do |t|
      t.string :app_id
      t.string :master_key
      t.string :client_key
      t.references :application, index: true

      t.timestamps null: false
    end
  end
end
