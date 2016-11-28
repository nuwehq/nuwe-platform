class V3::TeamsController < V3::BaseController

  before_action :doorkeeper_authorize!, except: [:index, :show]
  before_action :authenticate_application, only: [:index, :show]

  def index
    if doorkeeper_token
      @teams = current_user.teams.where(application_id: doorkeeper_token.application.id)
    elsif @application != nil
      @teams = Team.where(application_id: @application.id)
    else
      @teams = current_user.teams
    end
    render json: @teams
  end

  def create
    @team = Team.new team_params
    @team.memberships.build user: current_user, owner: true
    if doorkeeper_token
      @team.application_id = doorkeeper_token.application.id
    end
    if @team.save
      render json: @team, status: :created
    else
      render json: {error: {message: @team.errors.full_messages}}, status: :bad_request
    end
  end

  def show
    if current_user != nil
      @team = current_user.teams.find params[:id]
    else
      @team = Team.find params[:id]
    end
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
