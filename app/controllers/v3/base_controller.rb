class V3::BaseController < ApplicationController

  skip_before_action :verify_authenticity_token
  after_filter :create_stat

  private

  def authenticate_application
    if doorkeeper_token
      :doorkeeper_authorize!
    elsif request.headers["HTTP_AUTHORIZATION"].present?
      application_id, application_secret = request.headers["HTTP_AUTHORIZATION"].split(',')
      application_id.gsub!("application_id ", '')
      application_secret.gsub!(" client_secret ", '')
      @application = Doorkeeper::Application.find_by_uid(application_id)
      if @application != nil
        @user = @application.owner
      end
      unless @application.present? && @application.secret == application_secret
        render json: {error: {message: "Application ID and/or secret are not correct"}}, status: :unauthorized
      end
    else
      render json: {error: {message: "You are not authorized to see this"}}, status: :unauthorized
    end
  end

  def create_stat
    if doorkeeper_token
      StatJob.perform_later(doorkeeper_token.application_id, Time.now.to_i, doorkeeper_token.resource_owner_id, request.path)
    else
      StatJob.perform_later(@application.id, Time.now.to_i, @application.owner_id, request.path)
    end
  end

  def find_team
    @team = Team.find params[:team_id]
  end

  def current_user
    # OPTIMIZE this should not be needed? where is current_user called?
    if doorkeeper_token
      @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
    end
  end
  helper_method :current_user

  def authenticate
    unless current_user
      render json: {error: {message: "Not working"}}, status: :unauthorized
    end
  end

  # nuwe_meals_service used in multiple controllers
  def nuwe_meals_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "nuwe_meals").present?
      render json: {error: {message: "Application has not enabled the Nuwe Meals service"}}, status: :unauthorized
    end
  end

  # nuwe_teams_service used in multiple controllers
  def nuwe_teams_service
    @application ||= Doorkeeper::Application.find(doorkeeper_token[:application_id])
    unless @application.services.where(lib_name: "nuwe_teams").present?
      render json: {error: {message: "Application has not enabled the Nuwe Teams service"}}, status: :unauthorized
    end
  end

  rescue_from ActionController::ParameterMissing, PG::InvalidTextRepresentation, JSON::ParserError do |exception|
    render json: {error: {message: exception.message}}, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: {message: exception.message}}, status: :not_found
  end
end
