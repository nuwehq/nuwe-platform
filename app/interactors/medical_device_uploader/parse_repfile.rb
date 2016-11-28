class MedicalDeviceUploader::ParseRepfile
  include Interactor

  delegate :medical_device, to: :context

  def call
    uploaded_file = context.upload.file
    if context.upload.upload_action == "rep-parser"
      RepfileWorker.new(uploaded_file, medical_device).perform
    end
  end
end
