class V1::EatsController < V1::BaseController

  before_action :authenticate

  def index
    eats = current_user.eats.includes(:components)
    paginate json: eats
  end

  def today
    # TODO this needs to be updated to be Time.zone sensitive
    eats = current_user.eats.where("eaten_on >= ?", Date.current)
    render json: eats
  end

  def create
    result = Eats::Create.call eat_params: eat_params, user: current_user

    if result.success?
      render json: result.eat, status: result.status
    else
      render json:{error: {message: result.message}}, status: result.status
    end
  end

  def update
    result = Eats::Update.call eat: Eat.find(params[:id]), eat_params: eat_params, user: current_user

    if result.success?
      render json: result.eat
    else
      render json:{error: {message: result.message}}, status: :bad_request
    end
  end


  def destroy
    @eat = Eat.find params[:id]
    if @eat.destroy
      render json: {notice: {message: "Eat event deleted.", eat: @eat}}
    else
      render json: {error: {message: @eat.errors.full_messages}}, status: :bad_request
    end
  end

  private

  def eat_params
    params.require(:eat).permit(:lat, :lon, components: %i(ingredient_id amount), meal_ids: [], product_upcs: [], places: [:name, :address, :lat, :lon] )
  end

end
