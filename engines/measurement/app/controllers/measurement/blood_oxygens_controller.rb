class Measurement::BloodOxygensController < V3::BaseController

  def index
    blood_oxygens = current_user.blood_oxygen_measurements
    paginate json: blood_oxygens
  end

  def create
    @measurement = current_user.blood_oxygen_measurements.new measurement_params

    if @measurement.save
      render json: @measurement, status: :created
    else
      render json: @measurement.errors, status: :not_acceptable
    end
  end

  private

  def measurement_params
    params.require(:measurement).permit(:date, :value, :timestamp)
  end
end
