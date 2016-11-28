class Meals::Update
  include Interactor::Organizer

  organize [

    Meals::FindMeal,
    Meals::Components,
    Meals::AddImages,
    Meals::Places,
    Meals::CreateFavourites

  ]
  
end
