class UiController < ApplicationController
  def index
  end

  def show
    page = params[:name]
    render "ui/#{page}"
  end
end
