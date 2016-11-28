class Meals::FindMeal
  include Interactor

  def call
    if meal.update context.to_h.slice(:name, :user_id, :type, :lat, :lon)
      context.meal = meal
    else
      context.status = :bad_request
      context.fail! message: meal.errors.full_messages
    end
  end

  private

  def meal
    Meal.find context.id
  end

end
