class V3::UsdaIngredientsController < V3::BaseController

  before_action :authenticate_application
  before_action :usda_service

  def index
    if params[:name].present?
      @ingredients = Ingredient.search(params[:name]).results
    else
      @ingredients = Ingredient.where(ingredient_group_id: nil)
    end
    paginate json: @ingredients, each_serializer: UsdaIngredientSerializer
  end

  private

  def usda_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "nuwe_ingredients").present?
      render json: {error: {message: "Application has not enabled the USDA Ingredients service"}}, status: :unauthorized
    end
  end

end
