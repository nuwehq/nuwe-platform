class ChangeColumnNameOauthApplicationInPurchases < ActiveRecord::Migration
  def change
    remove_index :purchases, :oauth_application_id
    rename_column :purchases, :oauth_application_id, :application_id
    add_index :purchases, :application_id
  end
end
