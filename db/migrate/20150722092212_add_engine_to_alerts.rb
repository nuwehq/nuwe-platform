class AddEngineToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :engine, :string
  end
end
