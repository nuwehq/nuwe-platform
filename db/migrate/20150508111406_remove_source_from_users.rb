class RemoveSourceFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :source, :string,  default: 'nuscore'
  end
end
