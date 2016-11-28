class AddFactualIngredientsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :factual_ingredients, :string, array: true, default: '{}'
  end
end
