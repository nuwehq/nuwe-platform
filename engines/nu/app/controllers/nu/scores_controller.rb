module Nu
  # Contains historical biometric, activity and nutrition scores.
  # All these scores must be pre-calculated via cron; this controller just fetches records from the DB.
  class ScoresController < ::V1::BaseController

    before_action :authenticate, :unless => :version_3?
    before_action :authenticate_v3, :if => :version_3?

    before_action :find_team, only: [:index]

    def index
      days = []
      Date.yesterday.downto(length.days.ago.to_date) do |date|
        if @team
          days << Nu::TeamScores.new(date, @team).result
        else
          days << Nu::DayScores.new(date, current_user).result
        end
      end
      render json: days
    end

    def today
      version = request.path.split('/').second
      # TODO use exceptions for flow control instead of the manual check.
      if current_user.historical_scores.find_by(date: Date.current).try(:dcn).nil?
          render json: {error: {message: "A DCN value is required for user.", user: current_user}}, status: :bad_request
      elsif version == "v1"
        score_today =
          {
            "historical_score" => current_user.historical_scores.find_by(date: Date.current),
            "breakdown" => Nutrition::Calculate::Breakdown.new(current_user, Date.current).results
          }
        render json: score_today
      elsif version == "v2" || version == "v3"
        score_today =
          {
            "biometric_score" => current_user.biometric_score,
            "activity_score" => current_user.activity_score,
            "nutrition_score" => current_user.nutrition_score,
            "nu_score" => current_user.nu_score,
            "breakdown" => Nutrition::Calculate::Breakdown.new(current_user, Date.current).results
          }
        render json: score_today
      end
    end

    def week
      week = []
      Date.yesterday.downto(7.days.ago.to_date) do |date|
        week << {
          date: date,
          breakdown: current_user.breakdowns.find_by(date: date),
          historical_score: current_user.historical_scores.find_by(date: date)
        }
      end
      render json: week
    end

    private
    # How many days worth of data to return.
    def length
      length = params[:days].to_i rescue 30
      length = 30 if length <= 0
      length = 30 if length > 30
      length
    end

    def find_team
      if params[:team_id]
        @team = Team.find params[:team_id]
      end
    end

    def version_3?
      version = request.path.split('/').second
      if version == "v3"
        return true
      end
    end
  end
end
