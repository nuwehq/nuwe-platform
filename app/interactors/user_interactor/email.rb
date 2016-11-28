module UserInteractor
  class Email

    include Interactor

    def call
      UserMailer.register_confirm(context.user).deliver_later
    end

  end
end
