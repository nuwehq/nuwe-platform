class V3::IngredientGroupsController < V3::BaseController

  before_action :authenticate_application
  before_action :usda_service

  def index
    @ingredient_groups = IngredientGroup.all
    render json: @ingredient_groups
  end

  private

  def usda_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "nuwe_ingredients").present?
      render json: {error: {message: "Application has not enabled the USDA Ingredients service"}}, status: :unauthorized
    end
  end

end
