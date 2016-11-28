class AddsGcmSenderIdAndGcmApiKeyToParseApps < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :gcm_sender_id, :string
    add_column :oauth_applications, :gcm_api_key, :string
  end
end
