class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :oauth_access_tokens, :application_id
    add_index :oauth_access_grants, :application_id
    add_index :images, ["imageable_id", "imageable_type"]
    add_index :favourites, ["favouritable_id", "favouritable_type"]
    add_index :column_values, :medical_device_id
  end
end
