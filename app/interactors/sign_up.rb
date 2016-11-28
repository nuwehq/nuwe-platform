# Used to sign up to Nuwe.
class SignUp
  include Interactor::Organizer

  organize [
    UserInteractor::AuthenticateApplication,
    UserInteractor::Create,
    UserInteractor::Defaults,
    UserInteractor::Email,
    UserInteractor::AddInvitedTeams,
    UserInteractor::CreateAccessToken,
    IntercomInteractor::User
  ]

end
