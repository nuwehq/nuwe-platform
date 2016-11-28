class ChangeDefaultUserLimitsToFalseonOauthApplications < ActiveRecord::Migration
  def change
    change_column :oauth_applications, :user_limit, :boolean, default: false
  end
end
