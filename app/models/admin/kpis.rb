# Key Performance Indicators
# Gathered in one convenient class.
class Admin::Kpis

  def initialize(**options)
    @options = {
      from:     Time.current.beginning_of_day,
      to:       Time.current.end_of_day
    }.merge(options)
  end

  def all
    {
      new_users: new_users,
      new_teams: new_teams,
      notifications: new_team_notifications,
      invitations: new_invitations
    }
  end

  private

  # Create a dynamic method for created model count in the given time period.
  #
  # For example:
  #
  #   def new_users
  #     User.where(created_at: @options[:from]..@options[:to]).count
  #   end
  #
  %w(user team team_notification invitation).each do |kpi|
    define_method "new_#{kpi.pluralize}" do
      kpi.
        classify.
        constantize.
        where(created_at: @options[:from]..@options[:to]).
        count
    end
  end

end
