class AddMailgunDetailsToOauthApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :mailgun_api_key, :string
    add_column :oauth_applications, :mailgun_domain, :string
    add_column :oauth_applications, :mailgun_from_address, :string
  end
end
