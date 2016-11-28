class AddRequestLimitToOauthApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :request_limit, :boolean, default: false
  end
end
