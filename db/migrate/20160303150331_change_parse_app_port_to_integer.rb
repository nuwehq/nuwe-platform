class ChangeParseAppPortToInteger < ActiveRecord::Migration
  def change
    remove_column :parse_apps, :port, :string
    add_column :parse_apps, :port, :integer
  end
end
