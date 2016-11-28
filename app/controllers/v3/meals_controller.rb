class V3::MealsController < V3::BaseController

  before_action :doorkeeper_authorize!, only: [:destroy, :index]
  before_action :authenticate_application, only: [:all, :create, :search, :update, :show]
  before_action :nuwe_meals_service

  def all
    meals = Meal.all
    paginate json: meals
  end

  def index
    meals = current_user.meals
    paginate json: meals
  end

  def search
    @meals = Meal.search(params[:q]).results
    paginate json: @meals
  end

  def create
    @user ||= current_user
    result = Meals::Create.call user: @user, meal_params: meal_params

    if result.success?
      render json: result.meal, status: result.status
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def update
    result = Meals::Update.call meal_params.merge(id: params[:id])

    if result.success?
      render json: result.meal
    else
      render json: {error: {message: result.message}}, status: result.status
    end
  end

  def destroy
    @meal = Meal.find(params[:id])

    if @meal.destroy
      render json: {notice: {message: "Meal deleted.", meal: @meal}}
    else
      render json: {error: {message: @meal.errors.full_messages}}, status: :bad_request
    end
  end

  def show
    @meal = Meal.find(params[:id])
    render json: @meal
  end

  private

  def meal_params
    params.require(:meal).permit(:name, :favourite, :type, :lat, :lon, images: [], components: [:ingredient_id, :amount], places: [:name, :address, :lat, :lon])
  end

end
