class ProductInteractor::CreateFavourites
  include Interactor

  def call
    if context.favourite
      context.user.favourites.create favouritable: context.product
    end
  end
end
