class ImageSerializer < ActiveModel::Serializer
  attributes :image

  def image
    {
      tiny:     root_url.chop + object.image.url(:tiny),
      small:    root_url.chop + object.image.url(:small),
      medium:   root_url.chop + object.image.url(:medium)
    }
  end
end