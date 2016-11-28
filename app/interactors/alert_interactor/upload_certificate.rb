module AlertInteractor
  class UploadCertificate
    include Interactor

    def call
      application = context.application

      application.update_attributes context.application_params
      if application.save!
        context.application = application
        ParseServiceWorker.new(application).update_env_vars
      else
        context.fail! message: "Something went wrong. Please try again."
      end
    end

  end
end
