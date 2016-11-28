class TeamSerializer < ActiveModel::Serializer

  attributes :id, :name, :activity_goal, :nutrition_goal, :biometric_goal

  has_many :memberships, :achievements

end
