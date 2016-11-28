class UpdateProfileFromAttributes

  include Interactor

  def call
    if context.profile.update context.profile_params
      context.status = :ok
    else
      context.status = :forbidden
      context.fail! message: context.profile.errors.full_messages
    end
  end

end
