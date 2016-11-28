class InvitationSerializer < ActiveModel::Serializer

  attributes :email
  has_one :team

end
