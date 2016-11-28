class CreateColumnValues < ActiveRecord::Migration
  def change
    create_table :column_values do |t|
      t.string :field_name, null: false
      t.string :type, null: false
      t.boolean :readonly, null: false
      t.string :editor, null: false
      t.references :device_result, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
