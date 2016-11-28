class FavouriteSerializer < ActiveModel::Serializer
  attributes :favouritable_type, :favouritable_id, :created_at, :meal, :upc, :preview

  def meal
    object.favouritable if object.favouritable_type == 'Meal'
  end


  def upc
    object.favouritable.upc if object.favouritable_type == 'Product'
  end

  def preview
    if object.favouritable_type == 'Meal'
      MealPreview.new(current_user, meal: object.favouritable).results
    elsif object.favouritable_type == 'Product'
      MealPreview.new(current_user, product: object.favouritable).results
    end
  rescue MealPreview::DcnNeededError => message
      {error: {message: message}}
  end
end
