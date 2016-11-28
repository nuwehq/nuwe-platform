class ChangeValueForDataInResults < ActiveRecord::Migration
  def up
    change_column :device_results, :values, :string
  end
  def down
    change_column :device_results, :values, :hstore
  end
end
