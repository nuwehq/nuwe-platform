class DoorkeeperInteractor::DoorkeeperApplication
  include Interactor::Organizer

  organize [
    DoorkeeperInteractor::CreateApplication,
    DoorkeeperInteractor::AddServices
  ]

end
