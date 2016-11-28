class V1::MealPreviewsController < V1::BaseController

  before_action :authenticate, :require_meal_preview
  
  def create
    @meal_preview = MealPreview.new(current_user, components: params[:meal_preview][:components])
    render json: @meal_preview.results
  end

  private

  def require_meal_preview
    unless params[:meal_preview].present?
      render json: {error: {message: ["You must provide a meal preview with one or more components"]}}, status: :bad_request
    end
  end

  rescue_from MealPreview::DcnNeededError do |exception|
    render json: {error: {message: [exception.message]}}, status: :not_found
  end
  
end
