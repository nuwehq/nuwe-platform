class Eats::Update
  include Interactor::Organizer

  before do
    context.components = context.eat_params.delete(:components)
    context.meal_ids = context.eat_params.delete(:meal_ids)
    context.product_upcs = context.eat_params.delete(:product_upcs)
    context.places = context.eat_params.delete(:places)
  end

  organize [
    Eats::FindEat,
    Eats::ComponentsMeals,
    Eats::Places,
    Eats::CalculateBreakdown,
    Eats::CalculateDailyScores
  ]
  
end
