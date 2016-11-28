class AddPortToParseApps < ActiveRecord::Migration
  def change
    add_column :parse_apps, :port, :string
  end
end
