class V3::InvitationsController < V3::BaseController

  before_action :doorkeeper_authorize!, :find_team
  before_action :nuwe_teams_service

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
