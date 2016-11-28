# Update an existing user's profile.
# Requires a valid API token.
class V3::ProductsController < V3::BaseController

  before_action :authenticate_application
  before_action :nuwe_meals_service
  before_action :factual_upc_service, only: [:show]

  def show
    result = ProductInteractor::Fetch.call({upc: params[:id], application: @application})
    if result.success?
      render json: result.product
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def update
    result = ProductInteractor::Update.call product_params.merge({upc: params[:id], user: current_user})
    if result.success?
      result.product.reload
      render json: result.product
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def search
    render json: {error: {message: "'name' parameter is required"}}, status: :bad_request and return if params[:name].blank?

    result = ProductInteractor::SearchProducts.call(name: params[:name], page: params[:page])
    if result.success?
      render json: result.products
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  private

  def factual_upc_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "factual_upc").present?
      render json: {error: {message: "Application has not enabled the Factual UPC service"}}, status: :unauthorized
    end
  end

  def product_params
    params.require(:product).permit(:type, :lat, :lon, :favourite, places: [:name, :address, :lat, :lon])
  end

end
