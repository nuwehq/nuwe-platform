class V1::AppsController < V1::BaseController

  before_action :authenticate

  def index
    render json: AppList.new(current_user).list
  end

  def update
    @app = current_user.apps.find_by! provider: params[:id]

    if @app.update app_params
      render json: AppList.new(current_user).list
    else
      render json: {error: {message: @app.errors.full_messages}}, status: :bad_request
    end
  end

  def destroy
    current_user.apps.where(provider: params[:id]).destroy_all

    IntercomInteractor::App.new(user: current_user)
    render json: AppList.new(current_user).list
  end

  private

  def app_params
    params.require(:app).permit(:position)
  end

end
