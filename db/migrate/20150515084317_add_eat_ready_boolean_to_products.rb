class AddEatReadyBooleanToProducts < ActiveRecord::Migration
  def change
    add_column :products, :eat_ready, :boolean
    execute "update products set eat_ready = 't'"
  end
end
