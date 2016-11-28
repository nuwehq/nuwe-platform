class DropCreatedFromParseApps < ActiveRecord::Migration
  def change
    remove_column :parse_apps, :created
  end
end
