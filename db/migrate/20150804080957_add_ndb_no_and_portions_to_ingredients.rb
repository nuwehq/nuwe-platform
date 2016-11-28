class AddNdbNoAndPortionsToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :ndb_no, :integer
    add_column :ingredients, :portions, :hstore, default: {}, null: false
  end
end
