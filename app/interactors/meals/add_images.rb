class Meals::AddImages
  include Interactor

  def call
    return unless context.images

    context.meal.images.clear
    context.images.each do |i|
      image = Image.new image: i
      image.imageable = context.meal

      unless image.save
        context.status = :bad_request
        context.fail! message: image.errors.full_messages
      end
    end
  end
  
end
