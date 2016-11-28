class DropFavouritesMealIdFk < ActiveRecord::Migration
  def change
    execute "ALTER TABLE favourites DROP CONSTRAINT IF EXISTS favourites_meal_id_fk"
  end
end
