class AddColumnsToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :proximates, :hstore, default: {}, null: false
    add_column :ingredients, :minerals, :hstore, default: {}, null: false
    add_column :ingredients, :vitamins, :hstore, default: {}, null: false
    add_column :ingredients, :lipids, :hstore, default: {}, null: false
    add_column :ingredients, :other, :hstore, default: {}, null: false
  end
end
