class Measurement::WeightMeasurementsController < Measurement::BaseController

  def index
    @measurements = Measurement::Weight.where(user_id: user_ids).page(params[:page])
    
    respond_to do |format|
      format.html
      format.json { render json: @measurements }
    end
  end

end
