module UserInteractor
  class Create
    include Interactor

    def call
      if new_user.save
        new_user.profile.update facebook_id: context.facebook_id
        context.user_id = new_user.id
        context.user = new_user
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: new_user.errors.full_messages
      end
    end

    private

    def new_user
      # need to slice only user-specific fields out of the context
      # other fields pertain to the user's profile instead
      @user ||= User.new context.to_h.slice(:email, :password)
    end

  end
end
