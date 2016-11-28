class CollaborationsController < ApplicationController
  before_action :find_application, only: [:create]

  def create
    @collaborator = User.find_by(email: params[:email])
    if @collaborator.present?
      @collaboration = Collaboration.new(application: @application, user: @collaborator)
      if @collaboration.save
        redirect_to oauth_application_path(@application), notice: "A collaborator has been added!"
        CollaborationMailer.user_added(@application, @collaborator).deliver_later
      end
    else
      redirect_to oauth_application_path(@application), alert: "User not found."
    end
  end

  def destroy
    @collaboration = Collaboration.find params[:id]
    @application = @collaboration.application
    @collaboration.destroy
    redirect_to oauth_application_path(@application), notice: "Collaborator removed."

  end

end
