require 'grocer'

# Send a notification to a team after an achievement has been reached.
class AchievementWorker

  include Sidekiq::Worker

  def perform(team_id, achievement)
    @team = Team.find(team_id)

    @team.users.each do |user|
      user.devices.each do |device|
        apn = Grocer::Notification.new(
          device_token:         device.token,
          alert:                I18n.t(achievement, scope: "achievement", name: @team.name)
        )

        pusher.push(apn)
      end
    end
  end

  private

  def pusher
    @pusher ||= Grocer.pusher(
      certificate: ENV['APNS_CERTIFICATE_PATH']
    )
  end

end
