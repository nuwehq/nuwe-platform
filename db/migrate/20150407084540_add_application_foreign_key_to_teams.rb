class AddApplicationForeignKeyToTeams < ActiveRecord::Migration
  def change
    add_foreign_key :teams, :oauth_applications, column: :application_id, on_delete: :cascade
  end
end
