class V3::SearchesController < V3::BaseController

  before_action :authenticate_application


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
    @user ||= current_user
    User.where.not(id: @user.id)
  end

  def search_params
    params[:search] || {}
  end

end
