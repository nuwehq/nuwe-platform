class AddApplicationToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :application, index: true
  end
end
