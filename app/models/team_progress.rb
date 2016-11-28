require 'grocer'

# Determine progress of a Team.
#
# We do this by creating achievements and sending notifications to team members.
class TeamProgress

  MILESTONES = [5, 10, 20, 50]
  STREAKS = [5, 10]

  def initialize(team)
    @team = team
  end

  def milestones
    MILESTONES.each do |milestone|
      name = "milestone.#{milestone}"
      create_progress(name) if @team.created_at <= milestone.days.ago
    end
  end

  def streaks
    streaks = {activity: 0, nutrition: 0, biometric: 0}
    @team.historical_scores.order(:date).find_each do |historical_score|

      Nu::Score::TYPES.each do |type|
        if @team.send("#{type}_goal") && historical_score.send(type) && historical_score.day_before.present?
          streaks[type] += 1 if historical_score.send(type) >= @team.send("#{type}_goal")
          STREAKS.each do |streak|
            name = "streak.#{type}.#{streak}"
            create_progress(name) if streaks[type] == streak
          end
        else
          streaks[type] = 0
        end
      end

    end
  end

  def goals
    Nu::Score::TYPES.each do |type|
      name = "goal.#{type}"
      goal = @team.historical_scores.where("#{type} >= ?", @team.send("#{type}_goal")).first

      create_progress(name) if goal
    end
  end

  def hiscores
    Nu::Score::TYPES.each do |type|
      name = "highest.#{type}"

      if @team.historical_scores.where("date >= ?", @team.created_at + 3.days).present?
        maximum = @team.historical_scores.maximum(type)
        score = @team.historical_scores.where("date >= ?", @team.created_at + 3.days).where("#{type} >= ?", maximum).order(:date).first

        create_progress(name) if score
      end
    end
  end

  private

  def create_progress(name)
    return if @team.achievements.where(name: name).present?

    @team.achievements.create! name: name
    AchievementWorker.perform_async @team.id, name
  end

end
