class AddRemoteCredentialsToCapabilities < ActiveRecord::Migration
  def change
    add_column :capabilities, :remote_application_key, :string
    add_column :capabilities, :remote_application_secret, :string
  end
end
