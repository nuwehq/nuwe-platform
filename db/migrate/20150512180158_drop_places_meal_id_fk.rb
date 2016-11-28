class DropPlacesMealIdFk < ActiveRecord::Migration
  def change
    execute "ALTER TABLE places DROP CONSTRAINT IF EXISTS places_meal_id_fk"
  end
end
