class AddApnsCertificateToApplications < ActiveRecord::Migration
  def change
    remove_column :oauth_applications, :apns_certificate
    add_attachment :oauth_applications, :apns_certificate
  end
end
