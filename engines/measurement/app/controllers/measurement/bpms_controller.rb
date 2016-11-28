class Measurement::BpmsController < V3::BaseController

  before_action :authenticate

  def index
    steps = current_user.bpm_measurements
    paginate json: steps
  end

  def create
    @measurement = current_user.bpm_measurements.new measurement_params

    if @measurement.save
      render json: @measurement, status: :created
    else
      render json: @measurement.errors, status: :not_acceptable
    end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:value, :date, :timestamp)
  end

end
