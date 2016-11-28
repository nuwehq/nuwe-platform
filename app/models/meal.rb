class Meal < ActiveRecord::Base
  searchkick

  def search_data
    as_json only: [:name]
  end

  self.inheritance_column = nil # because we have a column "type"

  belongs_to :user

  has_many :components, as: :composable, after_add: :calculate_nutrients, after_remove: :calculate_nutrients
  has_many :ingredients, through: :components

  validates_presence_of :user
  validates_presence_of :name
  validates :type, inclusion: { in: %w( breakfast lunch dinner snack ),
    message: "%{value} is not a valid meal type" }, allow_nil: true

  has_and_belongs_to_many :eats

  has_many :images, as: :imageable
  has_many :favourites, as: :favouritable
  has_many :places, as: :placeable
  has_many :users, through: :favourites

  private

  # Tally nutrient totals for this meal based on all components.
  #
  # The +component+ parameter is ignored since we're calculating everything from scratch each time.
  def calculate_nutrients(component)
    self.protein = self.carbs = self.kcal = self.fibre = self.fat_s = self.fat_u = self.salt = self.sugar = 0

    components.each do |component|
      self.protein      += component.ingredient.protein * component.amount
      self.carbs        += component.ingredient.carbs * component.amount
      self.kcal         += component.ingredient.kcal * component.amount
      self.fibre        += component.ingredient.fibre * component.amount
      self.fat_s        += component.ingredient.fat_s * component.amount
      self.fat_u        += component.ingredient.fat_u * component.amount
      self.salt         += component.ingredient.salt * component.amount
      self.sugar        += component.ingredient.sugar * component.amount
    end

    save
  end

end
