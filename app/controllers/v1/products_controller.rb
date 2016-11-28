# Update an existing user's profile.
# Requires a valid API token.
class V1::ProductsController < V1::BaseController

  before_action :authenticate

  def show
    result = ProductInteractor::Fetch.call({upc: params[:id]})

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

  private

  def product_params
    params.require(:product).permit(:type, :lat, :lon, :favourite, places: [:name, :address, :lat, :lon])
  end

end
