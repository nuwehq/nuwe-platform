class CollaborationMailer < ActionMailer::Base
  default from: "tech@nuwe.co"

  def user_added(application, collaborator)
    @application = application
    @owner = application.owner
    @collaborator = collaborator

    mail(to: @collaborator.email, subject: "You've been added as a collaborator on a Nuwe app!")
  end

end
