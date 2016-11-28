class V1::InvitationsController < V1::BaseController

  before_action :authenticate, :find_team

  def create
    @invitation = @team.invitations.new invitation_params

    if @invitation.save
      InvitationMailer.team(@invitation).deliver_later
      render json: @invitation, status: :created
    else
      render json: @invitation.errors.full_messages, status: :bad_request
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email).merge(user_id: current_user.id)
  end

end
