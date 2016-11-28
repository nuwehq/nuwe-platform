class Service < ActiveRecord::Base

  validates_presence_of :name

  has_attached_file :icon, styles: { tiny: "100x100#", small: "250x250#", medium: "500x500#" }
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/

  has_many :capabilities, dependent: :nullify
  belongs_to :service_category

  # Derive an identifying type string from the category, fallback to the name.
  def type
    if service_category
      service_category.name.downcase
    else
      name.parameterize
    end
  end

end
