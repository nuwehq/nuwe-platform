class MealSerializer < ActiveModel::Serializer

  attributes :name, :id, :user_id, :type, :creator, :preview, :lat, :lon, :favourite

  has_many :components
  has_many :images
  has_many :places

  def creator
  {
    name: object.user.full_name,
    avatar: {
      tiny:     root_url.chop + object.user.avatar.url(:tiny),
      small:    root_url.chop + object.user.avatar.url(:small),
      medium:   root_url.chop + object.user.avatar.url(:medium)
    }
  }
  end

  def preview
    if current_user.present?
      MealPreview.new(current_user, meal: self).results
    else
      []
    end
  rescue MealPreview::DcnNeededError => message
    {error: {message: message}}
  end

  def favourite
    if current_user.present?
      object.users.include?(current_user)
    else
      []
    end
  end

end
