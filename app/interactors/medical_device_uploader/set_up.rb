class MedicalDeviceUploader::SetUp
  include Interactor::Organizer

  organize [
    MedicalDeviceUploader::StoreFile,
    MedicalDeviceUploader::ParseRepfile,
    MedicalDeviceUploader::AddColumns
  ]

end
