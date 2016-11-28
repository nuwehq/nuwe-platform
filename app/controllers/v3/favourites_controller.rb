class V3::FavouritesController < V3::BaseController

  before_action :doorkeeper_authorize!
  before_action :nuwe_meals_service

  def index
    @favourites = current_user.favourites
    paginate json: @favourites
  end

  def create
    if params[:meal_id]
      @meal = Meal.find(params[:meal_id])
      favourite = current_user.favourites.create(favouritable: @meal)
    elsif params[:product_id]
      @product = Product.find_by_upc(params[:product_id])
      favourite = current_user.favourites.create(favouritable: @product)
    end
    if favourite.save
      render json: favourite, status: :created
    else
      render json:{error: {message: favourite.errors.full_messages}}, status: :bad_request
    end
  end

  def destroy
    if params[:meal_id]
      @meal = Meal.find(params[:meal_id])
      @favourite = current_user.favourites.where(favouritable: @meal).destroy_all
      render json: {notice: {message: "Item no longer favourite.", favouritable: @meal}}
    elsif params[:product_id]
      @product = Product.find_by_upc(params[:product_id])
      @favourite = current_user.favourites.where(favouritable: @product).destroy_all
      render json: {notice: {message: "Item no longer favourite.", favouritable: @product}}
    end

  end
end
