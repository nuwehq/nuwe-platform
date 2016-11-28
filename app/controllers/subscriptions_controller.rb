class SubscriptionsController < ApplicationController

  def index
    @subscriptions = Subscriptions.all
  end


end