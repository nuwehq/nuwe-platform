class AddPriceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :price, :integer
  end
end
