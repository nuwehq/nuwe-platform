class ParseAppsController < ApplicationController

  before_action :require_admin


  def index
    @parse_apps = ParseApp.order(created_at: :asc)
  end

  def edit
    @parse_app = ParseApp.find params[:id]
  end

  def update
    @parse_app = ParseApp.find params[:id]
    if @parse_app.update parse_apps_params
      redirect_to parse_apps_path, notice: "Parse App for application '#{@parse_app.application_id}' is updated"
    else
      render edit
    end
  end

  def destroy
    @parse_app = ParseApp.find params[:id]
    if @parse_app.destroy
      redirect_to parse_apps_path, notice: "Parse App removed."
    else
      render index, notice: "Something went wrong. Please try again."
    end
  end

  private

  def require_admin
    redirect_to unauthorized_path, notice: "You are not authorized to perform that action" unless current_user.roles.include?("admin")
  end

  def parse_apps_params
    params.require(:parse_app).permit(:port, :bucket)
  end

end
