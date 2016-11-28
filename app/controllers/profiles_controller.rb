class ProfilesController < ApplicationController
  respond_to :html, :js

  def update
    @profile = current_user.profile
    @profile.technologies = params[:tech].split(",").delete_if(&:empty?)
    update_user = @profile.update_attributes(profile_params)

    respond_to do |format|
      if update_user
        if remotipart_submitted?
          format.js { render plain: @profile.avatar.url(:medium), status: :ok}
        else
          format.html { redirect_to user_path, notice: "Your profile has been updated." }
        end
      else
        if remotipart_submitted?
          format.js { render plain: update_user, status: :bad_request }
        else
          format.html { redirect_to user_path, alert: "There was an error. Please try again." }
        end
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar, :title, :about, :location)
  end

end