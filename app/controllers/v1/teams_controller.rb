class V1::TeamsController < V1::BaseController

  before_action :authenticate

  def index
    render json: current_user.teams
  end

  def create
    @team = Team.new team_params
    @team.memberships.build user: current_user, owner: true

    if @team.save
      render json: @team, status: :created
    else
      render json: {error: {message: @team.errors.full_messages}}, status: :bad_request
    end
  end

  def show
    @team = current_user.teams.find params[:id]

    render json: @team
  end

  def update
    @team = current_user.teams.find params[:id]

    if @team.update team_params
      render json: @team, status: :ok
    else
      render json: {error: {message: @team.errors.full_messages}}, status: :bad_request
    end
  end

  def destroy
    @team = Team.find params[:id]

    if @team.owners.include?(current_user)
      if @team.destroy
        render json: {notice: {message: "This team exists no more.", team: @team}}, status: :ok
      else
        render json: {error: {message: "Could not remove this team.", team: @team}}, status: :bad_request
      end
    else
      render json: {error: {message: "Only owners can remove this team.", team: @team}}, status: :bad_request
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :activity_goal, :nutrition_goal, :biometric_goal)
  end

end
