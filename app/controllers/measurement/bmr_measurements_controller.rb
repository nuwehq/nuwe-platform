class Measurement::BmrMeasurementsController < Measurement::BaseController

  def index
    @measurements = Measurement::Bmr.where(user_id: user_ids).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @measurements }
    end
  end

end
