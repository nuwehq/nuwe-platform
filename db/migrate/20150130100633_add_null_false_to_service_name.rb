class AddNullFalseToServiceName < ActiveRecord::Migration
  def change
    change_column :services, :name, :string, null: false
  end
end
