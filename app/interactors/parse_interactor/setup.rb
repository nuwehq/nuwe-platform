class ParseInteractor::Setup
  include Interactor::Organizer

  organize [
    ParseInteractor::CreateParseApp,
    ParseInteractor::AddAwsBucket,
    ParseInteractor::CreateParseOnServer
  ]
end
