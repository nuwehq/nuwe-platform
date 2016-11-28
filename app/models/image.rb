class Image < ActiveRecord::Base
  
  belongs_to :imageable, polymorphic: true

  has_attached_file :image, styles: { tiny: "120x120#", small: "320x320#", medium: "640x640#" }
  validates_attachment_content_type :image, :content_type => /\Aimage/
  
end
