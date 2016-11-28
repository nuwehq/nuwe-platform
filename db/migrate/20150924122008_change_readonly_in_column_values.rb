class ChangeReadonlyInColumnValues < ActiveRecord::Migration
  def up
    rename_column :column_values, :readonly, :read_only
  end
  def down
    rename_column :column_values, :read_only, :readonly
  end
end
