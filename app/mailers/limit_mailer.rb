class LimitMailer < ActionMailer::Base
  default from: "tech@nuwe.co"

  def limit_reached(application, which_limit)
    @application = application
    @user = application.owner
    @which_limit = which_limit

    mail(to: "tech@nuwe.co", subject: "#{@which_limit} reached on #{@application.name}")
  end
  
end
