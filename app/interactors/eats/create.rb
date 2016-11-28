class Eats::Create
  include Interactor::Organizer

  before do
    context.components = context.eat_params.delete(:components)
    context.places = context.eat_params.delete(:places)
    context.meal_ids = context.eat_params.delete(:meal_ids)
    context.product_upcs = context.eat_params.delete(:product_upcs)
  end

  organize [

    Eats::SetUp,
    Eats::ComponentsMeals,
    Eats::Places,
    Eats::CalculateBreakdown,
    Eats::CalculateDailyScores

  ]
  
end
