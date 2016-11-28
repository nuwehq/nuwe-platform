# Sits between either a Meal/Eat and an Ingredient.
# A Component represents a specific amount of a certain ingredient.
class Component < ActiveRecord::Base

  validates :ingredient_id, presence: true

  belongs_to :ingredient
  belongs_to :composable, polymorphic: true

end
