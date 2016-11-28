class InvitationMailer < UserMailer

  def team(invitation)
    @invitation = invitation
    @user = invitation.user
    @app_name = "Nuwe"

    mail(to: @invitation.email, subject: "Invitation to join a Nuwe team", from: from)
  end

end
