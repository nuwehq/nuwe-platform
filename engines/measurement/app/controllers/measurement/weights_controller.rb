class Measurement::WeightsController < V3::BaseController

  before_action :authenticate

  def index
    weights = current_user.weight_measurements
    paginate json: weights
  end

  def create
    @measurement = current_user.weight_measurements.new measurement_params

    if @measurement.save
      render json: @measurement, status: :created
    else
      render json: @measurement.errors, status: :not_acceptable
    end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:value, :date, :timestamp, :unit, :source)
  end
end
