class UpdateTextColumnOnAlerts < ActiveRecord::Migration
  def change
    change_column :alerts, :text, :string, null: false
  end
end
