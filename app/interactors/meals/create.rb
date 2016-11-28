class Meals::Create
  include Interactor::Organizer

  before do
    # put attributes of related models in a separate context key
    # this way the meal interactor only has to deal with meal attributes.
    context.components = context.meal_params.delete(:components)
    context.places = context.meal_params.delete(:places)
    context.images = context.meal_params.delete(:images)
    context.favourite = context.meal_params.delete(:favourite)
  end

  organize [

    Meals::SetUp,
    Meals::Components,
    Meals::AddImages,
    Meals::Places,
    Meals::CreateFavourites

  ]
  
end
