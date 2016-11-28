class MembershipSerializer < ActiveModel::Serializer

  attributes :owner

  has_one :user

end
