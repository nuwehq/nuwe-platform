class AddDataToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :data, :hstore, default: '', null: false
  end
end
