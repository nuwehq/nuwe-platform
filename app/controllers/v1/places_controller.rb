class V1::PlacesController < V1::BaseController
  before_action :authenticate
  
  def index
    result = FetchPlaces.call(params)

    if result.success?
      render json: result.data
    else
      render json:{error: {message: result.message}}, status: :bad_request
    end
  end
  
  def create
    result = PlacesInteractor::CreatePlaces.call meal_id: params[:meal_id], upc: params[:product_id], places: params[:places]

    if result.success?
      render json: result.object.reload, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def update
    result = PlacesInteractor::CreatePlaces.call meal_id: params[:meal_id], upc: params[:product_id], places: params[:places]

    if result.success?
      render json: result.object.reload, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end
  
  private
  def place_params
    params.require(:place).permit(:name, :address, :lat, :lon)
  end
end
