class AddAttributesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :title, :string
    add_column :profiles, :about, :string
    add_column :profiles, :technologies, :string, array: true, default: '{}'
    add_column :profiles, :location, :string
  end
end
