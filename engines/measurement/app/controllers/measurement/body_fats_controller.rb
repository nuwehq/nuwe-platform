class Measurement::BodyFatsController < V3::BaseController

  def index
    body_fats = current_user.body_fat_measurements
    paginate json: body_fats
  end

  def create
    @measurement = current_user.body_fat_measurements.new measurement_params

    if @measurement.save
      render json: @measurement, status: :created
    else
      render json: @measurement.errors, status: :not_acceptable
    end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:value, :timestamp, :date)
  end
end
