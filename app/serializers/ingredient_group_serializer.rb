class IngredientGroupSerializer < ActiveModel::Serializer
  attributes :id, :name, :icon

  has_many :ingredients, serializer: SimpleIngredientSerializer

  def icon
    {
      tiny:     root_url.chop + object.icon.url(:tiny),
      small:    root_url.chop + object.icon.url(:small),
      medium:   root_url.chop + object.icon.url(:medium)
    }
  end

end
