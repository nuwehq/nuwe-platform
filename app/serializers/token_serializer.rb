class TokenSerializer < ActiveModel::Serializer
  attributes :id, :scope, :created_at

  def scope
    object.scope
  end
end
