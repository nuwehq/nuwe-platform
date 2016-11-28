# Send a Push Notification to all team members.
class V3::NotificationsController < V3::BaseController

  before_action :doorkeeper_authorize!
  before_action :nuwe_teams_service

  def create
    @team = current_user.teams.find params[:team_id]
    @notification = @team.team_notifications.new notification_params
    if @notification.save
      NotificationJob.perform_later(@notification, @application)
      render json: @notification, status: :created, serializer: NotificationSerializer
    else
      render json: @notification.errors.full_messages, status: :bad_request
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:text).merge(user_id: current_user.id)
  end

end
