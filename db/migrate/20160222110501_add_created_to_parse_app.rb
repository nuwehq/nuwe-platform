class AddCreatedToParseApp < ActiveRecord::Migration
  def change
    add_column :parse_apps, :created, :boolean, default: false
  end
end
