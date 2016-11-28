class AddNuDateIndexes < ActiveRecord::Migration
  def change
    add_index :nu_biometrics, :date
    add_index :nu_activities, :date
    add_index :nu_nutritions, :date
  end
end
