class Measurement::StepsController < V1::BaseController

  before_action :authenticate

  def index
    steps = current_user.step_measurements
    paginate json: steps
  end

  def create
    steps = []
    params[:steps].present? && params[:steps].each_pair do |date, count|
      current_user.step_measurements.where(date: date).destroy_all
      steps << current_user.step_measurements.create(date: date, value: count)
      calculation = Nu::Calculate::Activity.new(current_user, date).score
      score = current_user.historical_scores.find_or_initialize_by(date: date)
      
      score.activity = calculation
      score.save!
    end

    current_user.apps.find_or_create_by provider: "m7", uid: current_user.to_param

    render json: steps
  end

end
