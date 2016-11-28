class AlertsController < ApplicationController
  before_action :find_application

  def new
    @alert = @application.alerts.new
  end

  def create
    @alert = @application.alerts.new alert_params
    if @alert.save
      redirect_to oauth_application_path(@application), notice: "The notification has been created."
    else
      render 'new', notice: "Sorry, please try again."
    end
  end

  def edit
    @alert = Alert.find params[:id]
  end

  def update
    @alert = Alert.find params[:id]
    if @alert.update_attributes(alert_params)
      redirect_to oauth_application_path(@application), notice: "The notification has been updated."
    else
      render edit_application_alert_path(@application,@alert), notice: "Sorry, please try again."
    end
  end

  def destroy
    @alert = Alert.find params[:id]
    if @alert.destroy
      redirect_to oauth_applications_path, notice: "The notification has been deleted."
    else
      render oauth_applications_path, notice: "Sorry, please try again."
    end
  end

  def certificate
  end

  def upload_certificate
    result = AlertInteractor::Setup.call application: @application, application_params: application_params
    if result.success?
      redirect_to oauth_application_path(@application), notice: "Thank you for updating your notification details."
    else
      redirect_to oauth_application_path(@application), notice: result.message
    end
  end

  private

  def alert_params
    params.require(:alert).permit(:text, :engine)
  end

  def application_params
    params.require(:doorkeeper_application).permit(:apns_certificate, :notification_bundleid, :notification_production, :gcm_sender_id, :gcm_api_key)
  end

end
