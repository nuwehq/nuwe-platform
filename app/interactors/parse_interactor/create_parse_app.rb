class ParseInteractor::CreateParseApp
  include Interactor

  def call
    application = context.application
    if application.parse_app.blank?
      parse_app = ParseApp.create(application: application)
    else
      parse_app = application.parse_app
    end
    if parse_app.present?
      context.parse_app = parse_app
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: "Parse App could not be created."
    end
  end
end
