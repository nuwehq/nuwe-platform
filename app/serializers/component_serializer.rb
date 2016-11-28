class ComponentSerializer < ActiveModel::Serializer
  attributes :ingredient_id, :ingredient_name, :amount, :protein, :carbs, :kcal, :fibre, :fat_s, :fat_u, :salt, :sugar, :small_portion, :medium_portion, :large_portion

  def ingredient_name
    object.ingredient.name
  end

  def protein
    object.ingredient.protein * amount
  end

  def carbs
    object.ingredient.carbs * amount
  end

  def kcal
    object.ingredient.kcal * amount
  end

  def fibre
    object.ingredient.fibre * amount
  end

  def fat_s
    object.ingredient.fat_s * amount
  end

  def fat_u
    object.ingredient.fat_u * amount
  end
  
  def salt
    object.ingredient.salt * amount
  end

  def sugar
    object.ingredient.sugar * amount
  end

  def small_portion
    object.ingredient.small_portion
  end 

  def medium_portion
    object.ingredient.medium_portion
  end

  def large_portion
    object.ingredient.large_portion
  end

end