class Eats::ComponentsMeals
  include Interactor

  def call
    eat_components      if context.components
    eat_meals           if context.meal_ids
    eat_products        if context.product_upcs
  end

  private

  def eat_components
    context.eat.components.clear
    context.components.each do |component|
      component = Component.new ingredient_id: component[:ingredient_id], amount: component[:amount]
      if component.save
        context.eat.components << component
      else
        context.status = :bad_request
        fail! message: component.errors.full_messages
      end
    end
  end


  def eat_meals
    context.eat.meals.clear
    context.meal_ids.each do |meal_id|
      context.eat.meals << Meal.find(meal_id)
    end
  end

  def eat_products
    context.eat.products.clear
    context.product_upcs.each do |product_upc|
      context.eat.products << Product.find_by_upc(product_upc)
    end
  end

end
