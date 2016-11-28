class AddUserLimitToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :user_limit, :boolean, default: true
  end
end
