class V1::Admin::UsersController < V1::Admin::BaseController

  def index
    @users = User.order(created_at: :desc)
    paginate json: @users
  end

  def show
    @user = User.find params[:id]
    render json: @user
  end

end
