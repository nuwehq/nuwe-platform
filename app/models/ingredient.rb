class Ingredient < ActiveRecord::Base
  searchkick

  validates_presence_of :name
  belongs_to :ingredient_group
  has_many :components

  def search_data
    as_json only: [:name, :ingredient_group_id]
  end

end
