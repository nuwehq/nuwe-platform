class V1::MealsController < V1::BaseController

  before_action :authenticate

  def all
    meals = Meal.all
    paginate json: meals
  end

  def index
    meals = current_user.meals
    paginate json: meals
  end

  def create
    result = Meals::Create.call user: current_user, meal_params: meal_params

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
