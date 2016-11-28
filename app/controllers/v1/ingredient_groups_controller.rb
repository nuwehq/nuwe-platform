class V1::IngredientGroupsController < V1::BaseController

  def index
    @ingredient_groups = IngredientGroup.all
    render json: @ingredient_groups
  end

end