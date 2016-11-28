class IngredientGroup < ActiveRecord::Base

  validates_presence_of :name
  has_many :ingredients

  has_attached_file :icon, styles: { tiny: "100x100#", small: "250x250#", medium: "500x500#" }
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
end
