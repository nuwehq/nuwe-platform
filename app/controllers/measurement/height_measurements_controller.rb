class Measurement::HeightMeasurementsController < Measurement::BaseController

  def index
    @measurements = Measurement::Height.where(user_id: user_ids).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @measurements }
    end
  end

end
