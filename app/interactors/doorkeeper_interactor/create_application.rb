class DoorkeeperInteractor::CreateApplication
  include Interactor

  def call
    application = Doorkeeper::Application.new context[:application_params]
    application.description = "Add your App description here"
    application.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    application.enabled = true
    application.owner = context.user if Doorkeeper.configuration.confirm_application_owner?

    if application.save
      context.application = application
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: application.errors
    end
  end

end
