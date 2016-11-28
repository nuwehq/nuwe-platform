class ChangeNotificationsToTeamNotifications < ActiveRecord::Migration
  def change
    rename_table :notifications, :team_notifications
  end
end
