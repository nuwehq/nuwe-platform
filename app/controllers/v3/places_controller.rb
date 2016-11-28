class V3::PlacesController < V3::BaseController

  before_action :authenticate_application
  before_action :factual_places_service, only: [:index]
  before_action :nuwe_places_service, only: [:create, :update]
  before_action :nuwe_meals_service, only: [:create, :update]

  def index
    result = FetchPlaces.call(params)
    if result.success?
      render json: result.data
    else
      render json: {error: {message: result.message}}, status: :bad_request
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

  def factual_places_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "factual_places").present?
      render json: {error: {message: "Application has not enabled the Factual Places service"}}, status: :unauthorized
    end
  end

  def nuwe_places_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "nuwe_places").present?
      render json: {error: {message: "Application has not enabled the Nuwe Places service"}}, status: :unauthorized
    end
  end

  def place_params
    params.require(:place).permit(:name, :address, :lat, :lon)
  end
end
