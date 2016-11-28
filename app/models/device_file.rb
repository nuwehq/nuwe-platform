class DeviceFile < ActiveRecord::Base
  belongs_to :medical_device, :dependent => :destroy

  has_attached_file :file
  validates_attachment :file,
    content_type: { content_type: "text/plain" },
    size:{ in: 10..500.kilobytes }

end
