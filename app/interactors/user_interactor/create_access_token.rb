module UserInteractor
  class CreateAccessToken
    include Interactor

    def call
      if context.application_id
        Doorkeeper::AccessToken.create!(:application_id => context.application_id, :resource_owner_id => context.user_id )
      end
    end
  end
end
