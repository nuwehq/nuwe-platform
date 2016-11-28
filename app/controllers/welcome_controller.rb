class WelcomeController < ApplicationController

  def index
    if user_signed_in?
      if current_user.roles.include?('developer')
        redirect_to oauth_applications_path
      else
        redirect_to no_developer_path
      end
     else
      render :text => "", :layout => "signup"
    end
  end

  def mail
    UserMailer.question_from_landing(params[:mail_type], params[:text]).deliver_later
    if request.xhr?
      render nothing: true
    else
      render "show"
    end
  end

  def evangelists
    @show_login = true
    render "index"
  end

end
