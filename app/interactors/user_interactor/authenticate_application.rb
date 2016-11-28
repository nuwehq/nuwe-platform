module UserInteractor
  class AuthenticateApplication
    include Interactor

    def call
      if context.headers.present?
        application_id, application_secret = context.headers.split(',')
        application_id.gsub!("application_id ", '')
        application_secret.gsub!(" client_secret ", '')
        application = Doorkeeper::Application.find_by_uid(application_id)

        unless application.present? && application.secret == application_secret
            context.status = :unauthorized
            context.fail! message: ["Application ID and/or secret are not correct"]
        end
        context.application_id = application.id
      end
    end
  end
end
