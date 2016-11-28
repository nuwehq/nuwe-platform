class ParseInteractor::CreateParseOnServer
  include Interactor

  def call
    application = context.application
    parse_app = application.parse_app
    unless parse_app.bucket.blank?
      ParseServiceWorker.new(application).perform
    end
  end
end
