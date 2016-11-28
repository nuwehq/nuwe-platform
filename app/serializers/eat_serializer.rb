class EatSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :created_at, :updated_at, :breakdown, :lat, :lon, :protein, :kcal, :carbs, :fibre, :fat_u, :fat_s, :salt, :sugar
  
  has_many :components
  has_many :meals
  has_many :products
  has_many :places

  def breakdown
    current_user.breakdowns.where(date: object.eaten_on).last
  end
end