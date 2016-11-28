require 'interactor'

# Link an OAuth application to an existing user using Omniauth.
module AppInteractor
  class Connect
    include Interactor::Organizer

    before do
      context.user = Token.find(context.state).user
    end

    organize [
      AppInteractor::Create,
      IntercomInteractor::App
    ]

  end
end
