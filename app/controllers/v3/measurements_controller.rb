class V3::MeasurementsController < V3::BaseController

  before_action :doorkeeper_authorize!

  # Controller now only accepts manual input of steps.
  # Can be expanded if necessary (into interactor please).

  def index
    steps = current_user.activity_measurements.where(type: "steps").all
    paginate json: steps
  end

  def create
    steps = []
    params[:steps].present? && params[:steps].each_pair do |date, count|
      current_user.activity_measurements.where(date: date).destroy_all
      steps << current_user.activity_measurements.create(date: date, steps: count, type: "steps", start_time: date, end_time: date)
      calculation = Nu::Calculate::Activity.new(current_user, date).score
      score = current_user.historical_scores.find_or_initialize_by(date: date)
      
      score.activity = calculation
      score.save!
    end

    current_user.apps.find_or_create_by provider: "m7", uid: current_user.to_param

    render json: steps
  end

end