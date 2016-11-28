module IntercomInteractor
  class User

    include Interactor

    def call
      context.intercom_user = intercom.users.create({
        email:          context.email,
        user_id:        context.user.id
      })
      intercom.users.save(context.intercom_user)
    end

    private

    def intercom
      Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'], api_key: ENV['INTERCOM_APP_API_KEY'])
    end

  end
end
