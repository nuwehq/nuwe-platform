# All controllers in the V1 API must inherit from this.
class V1::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token

  private

  def find_team
    @team = Team.find params[:team_id]
  end

  def logged_in?
    if token
      @current_user = token.user
    end
  end

  def token
    @token ||= authenticate_with_http_token do |token, options|
      Token.find(token)
    end
  end

  def authenticate
    unless logged_in?
      render json: {error: {message: "HTTP Token denied"}}, status: :unauthorized
    end
  end


  def authenticate_v3
    if doorkeeper_token
      :doorkeeper_authorize!
      @current_user ||= User.find(doorkeeper_token[:resource_owner_id])
    end
  end

  rescue_from ActionController::ParameterMissing, PG::InvalidTextRepresentation, JSON::ParserError do |exception|
    render json: {error: {message: exception.message}}, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {error: {message: exception.message}}, status: :not_found
  end

end
