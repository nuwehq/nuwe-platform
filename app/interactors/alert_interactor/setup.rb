class AlertInteractor::Setup
  include Interactor::Organizer

  organize [
    AlertInteractor::UploadCertificate
  ]

end
