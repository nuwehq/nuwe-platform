class UpdateData

  include Interactor

  def call
    if context.data.present? 
      if context.profile.update_attribute(:data, context.data)
        context.status = :ok
      else
        context.status = :forbidden
        context.fail! message: context.profile.errors.full_messages
      end
    end
  end

end
