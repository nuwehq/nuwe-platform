class Eats::Places
  include Interactor

  def call
    return unless context.places.present?

    context.eat.places.clear
    context.places.each do |p|
      place = Place.new name: p[:name], address: p[:address], lat: p[:lat], lon: p[:lon]
      place.placeable = context.eat.reload

      unless place.save
        context.status = :bad_request
        context.fail! message: place.errors.full_messages
      end
    end
  end
end
