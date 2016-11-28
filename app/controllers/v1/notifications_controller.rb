# Send a Push Notification to all team members.
class V1::NotificationsController < V1::BaseController

  before_action :authenticate

  def create
    @team = current_user.teams.find params[:team_id]
    @notification = @team.team_notifications.new notification_params
    if @notification.save
      NotificationJob.perform_later(@notification.id)
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
