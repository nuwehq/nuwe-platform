class PlacesInteractor::CreatePlaces
  include Interactor

  def call
    if context.meal_id
      context.object = Meal.find context.meal_id
    elsif context.upc
      context.object = Product.find_by_upc! context.upc
    end

    places if context.places
  end

  private

  def places
    context.object.places.clear

    context.places.each do |p|
      place = Place.create name: p[:name], address: p[:address], lat: p[:lat], lon: p[:lon]
      place.placeable = context.object
      if place.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: place.errors.full_messages
      end
    end
  end

end
