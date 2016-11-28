class Meals::Components
  include Interactor

  def call
    return unless context.components

    context.meal.components.clear
    
    context.components.each do |c|
      component = Component.new ingredient_id: c[:ingredient_id], amount: c[:amount]
      component.composable = context.meal

      if component.save
        context.meal.reload
      else
        context.status = :bad_request
        context.fail! message: component.errors.full_messages
      end
    end
  end
end
