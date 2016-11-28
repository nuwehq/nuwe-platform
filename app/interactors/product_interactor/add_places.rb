class ProductInteractor::AddPlaces
  include Interactor

  def call
    return unless context.places
    context.product.places.clear
    context.places.each do |p|
      place = Place.new name: p[:name], address: p[:address], lat: p[:lat], lon: p[:lon]
      place.placeable = context.product
      if place.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: place.errors.full_messages
      end
    end
  end
end
