class MedicalDeviceUploader::StoreFile
  include Interactor

  delegate :medical_device, to: :context

  def call
   device_file = medical_device.device_files.new
   device_file.file = context.file
   if context.filename.present?
     device_file.filename = context.filename
     device_file.file_file_name = context.filename
   end
   if context.upload_action.present?
     device_file.upload_action = context.upload_action
   end
   if device_file.save!
     context.upload = device_file
     context.status = :created
   else
     context.status = :bad_request
     context.fail! message: error.message
   end
  end
end
