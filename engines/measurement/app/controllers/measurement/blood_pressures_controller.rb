class Measurement::BloodPressuresController < V3::BaseController

  def index
    blood_pressures = current_user.blood_pressure_measurements
    paginate json: blood_pressures
  end

  def create
    @measurement = current_user.blood_pressure_measurements.new measurement_params

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
