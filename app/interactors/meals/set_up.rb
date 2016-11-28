class Meals::SetUp
  include Interactor

  def call
    meal = Meal.new context.meal_params
    meal.user = context.user

    if meal.save
      context.meal = meal
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: meal.errors.full_messages
    end
  end

end
