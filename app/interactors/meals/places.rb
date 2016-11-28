class Meals::Places
  include Interactor

  def call
    return unless context.places.present?

    context.meal.places.clear
    context.places.each do |p|
      place = Place.new name: p[:name], address: p[:address], lat: p[:lat], lon: p[:lon]
      place.placeable = context.meal.reload

      unless place.save
        context.status = :bad_request
        context.fail! message: place.errors.full_messages
      end
    end
  end
end
