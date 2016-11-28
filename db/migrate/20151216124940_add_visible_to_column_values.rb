class AddVisibleToColumnValues < ActiveRecord::Migration
  def change
    add_column :column_values, :visible, :boolean, default: true
    add_index :column_values, :visible
  end
end
