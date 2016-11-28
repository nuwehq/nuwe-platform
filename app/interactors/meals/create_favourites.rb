class Meals::CreateFavourites
  include Interactor

  def call
    if context.favourite
      context.meal.user.favourites.create favouritable: context.meal
    end
  end
end
