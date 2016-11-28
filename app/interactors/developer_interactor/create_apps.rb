class DeveloperInteractor::CreateApps
  include Interactor

  def call
    app = Developer::App.new context.app_params
    app.user = context.user

    if app.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: app.errors.full_messages
    end
  end

end
