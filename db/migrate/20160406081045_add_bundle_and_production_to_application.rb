class AddBundleAndProductionToApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :notification_bundleid, :string
    add_column :oauth_applications, :notification_production, :boolean, default: false
  end
end
