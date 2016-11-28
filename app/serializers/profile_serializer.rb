class ProfileSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :sex, :birth_date, :activity, :facebook_id, :avatar, :time_zone, :data

  def avatar
    {
      tiny:     root_url.chop + object.avatar.url(:tiny),
      small:    root_url.chop + object.avatar.url(:small),
      medium:   root_url.chop + object.avatar.url(:medium)
    }
  end
end
