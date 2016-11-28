class RenameColumnApplicationInStats < ActiveRecord::Migration
  def change
    remove_index :stats, :oauth_application_id
    rename_column :stats, :oauth_application_id, :application_id
    add_index :stats, :application_id
  end
end
