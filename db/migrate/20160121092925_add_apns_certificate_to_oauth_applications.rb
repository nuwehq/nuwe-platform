class AddApnsCertificateToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :apns_certificate, :text
  end
end
