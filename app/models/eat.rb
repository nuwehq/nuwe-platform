# The consumption of nutrients by a human.
#
# You can eat either a specific meal, or any number of components.
class Eat < ActiveRecord::Base

  before_create :eaten_on_today

  belongs_to :user

  has_many :components, as: :composable, after_add: :calculate_nutrients, after_remove: :calculate_nutrients
  has_and_belongs_to_many :meals, after_add: :calculate_nutrients, after_remove: :calculate_nutrients
  has_and_belongs_to_many :products, after_add: :calculate_nutrients, after_remove: :calculate_nutrients
  
  has_many :meal_components, through: :meals, class_name: "Component", source: :components
  
  has_many :places, as: :placeable

  private

  # Default to eating the Eat today, but it can be overridden.
  def eaten_on_today
    self.eaten_on ||= Date.current
  end

  # Tally all nutrients for this eat based on everything consumed.
  #
  # The +meal+ parameter is ignored sine we're calculating everything from scratch each time.
  def calculate_nutrients(meal)
    self.protein = self.carbs = self.kcal = self.fibre = self.fat_s = self.fat_u = self.salt = self.sugar = 0

    (meal_components | components).each do |component|
      self.protein      += component.ingredient.protein * component.amount
      self.carbs        += component.ingredient.carbs * component.amount
      self.kcal         += component.ingredient.kcal * component.amount
      self.fibre        += component.ingredient.fibre * component.amount
      self.fat_s        += component.ingredient.fat_s * component.amount
      self.fat_u        += component.ingredient.fat_u * component.amount
      self.salt         += component.ingredient.salt * component.amount
      self.sugar        += component.ingredient.sugar * component.amount
    end

    products.each do |product|
      self.protein    += product.protein
      self.kcal       += product.kcal
      self.carbs      += product.carbs
      self.fibre      += product.fibre
      self.fat_u      += product.fat_u
      self.fat_s      += product.fat_s
      self.salt       += product.salt
      self.sugar      += product.sugar
    end

    save
  end

end
