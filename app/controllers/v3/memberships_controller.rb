class V3::MembershipsController < V3::BaseController

  before_action :doorkeeper_authorize!, only: [:create]
  before_action :authenticate_application, only: [:destroy]
  before_action :find_team
  before_action :nuwe_teams_service

  def create
    @membership = @team.memberships.build membership_params

    if @membership.save
      render json: @team, status: :created
    else
      render json: {error: {message: @membership.errors.full_messages}}, status: 400
    end
  end

  # This action is used both by the resources :memberships (for admins)
  # and the resource :membership (for team members)
  def destroy
    if @team.owners.include?(current_user) 
      @membership = @team.memberships.find_by!(user_id: params[:id])
    elsif doorkeeper_token == nil
      @membership = @team.memberships.find_by!(user_id: params[:id])
    else
      @membership = @team.memberships.find_by!(user_id: current_user.id)
    end

    @membership.destroy
    render json: @team
  end

  private

  def find_team
    @team = Team.find params[:team_id]
  end

  def membership_params
    params.require(:membership).permit(:user_id)
  end

end
