class AddLibNametoServices < ActiveRecord::Migration
  def change
    add_column :services, :lib_name, :string
  end
end
