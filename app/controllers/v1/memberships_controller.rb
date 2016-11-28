class V1::MembershipsController < V1::BaseController

  before_action :authenticate, :find_team

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
