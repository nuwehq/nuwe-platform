class AddRemoteCredentialsBooleanToServices < ActiveRecord::Migration
  def change
    add_column :services, :needs_remote_credentials, :boolean, default: false
  end
end
