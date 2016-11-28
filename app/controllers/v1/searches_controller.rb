class V1::SearchesController < V1::BaseController

  before_action :authenticate

  def index
    if search_params && search_params[:email]
      @users = users.where(email: search_params[:email])
    else
      @users = users.page(params[:page]).per(params[:per_page])
    end

    render json: @users, each_serializer: UserSearchSerializer
  end

  private

  def users
    User.where.not(id: current_user.id)
  end

  def search_params
    params[:search] || {}
  end

end
