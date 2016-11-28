class Measurement::HeightsController < V3::BaseController

  before_action :authenticate

  def index
    heights = current_user.height_measurements
    paginate json: heights
  end


  def create
    @measurement = current_user.height_measurements.new measurement_params
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
