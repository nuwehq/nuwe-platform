class AddAttachmentFileToDeviceFiles < ActiveRecord::Migration
  def self.up
    change_table :device_files do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :device_files, :file
  end
end
