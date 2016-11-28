require 'interactor'

class ProductInteractor::Fetch
  include Interactor::Organizer

  organize [
    ProductInteractor::FindExisting,
    ProductInteractor::CheckCredentials,
    ProductInteractor::CreateFromFactual
  ]

end
