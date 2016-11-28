class ProductInteractor::Update
  include Interactor::Organizer

  organize [
    ProductInteractor::FindProduct,
    ProductInteractor::AddPlaces,
    ProductInteractor::CreateFavourites
  ]
  
end
