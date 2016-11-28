require 'i18n'

class AchievementSerializer < ActiveModel::Serializer

  attributes :name, :description, :created_at

  def description
    I18n.t(object.name, scope: "achievement", name: object.team.name)
  end

end
