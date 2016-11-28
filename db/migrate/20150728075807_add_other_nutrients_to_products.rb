class AddOtherNutrientsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :other_nutrients, :hstore, default: {}, null: false
  end
end
