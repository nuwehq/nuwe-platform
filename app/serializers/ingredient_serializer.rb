class IngredientSerializer < ActiveModel::Serializer
  attributes :id, :name, :protein, :carbs, :kcal, :fibre, :fat_s, :fat_u, :salt, :sugar, :small_portion, :medium_portion, :large_portion

end
