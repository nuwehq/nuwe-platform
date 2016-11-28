class AddLafToActivities < ActiveRecord::Migration
  def change
    add_column :nu_activities, :laf, :decimal
  end
end
