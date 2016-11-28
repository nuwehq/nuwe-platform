class UserData::BaseController < ApplicationController
  before_action :find_application

  private

  def user_ids
    Doorkeeper::AccessGrant.where(application: @application).map{|grant| grant.resource_owner_id}.uniq
  end


end
