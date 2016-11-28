# Return Key Performance Indicators for Nuwe.
class V1::Admin::KpisController < V1::Admin::BaseController

  before_action :authenticate

  def show
    if params[:from] && params[:to]
      @kpis = ::Admin::Kpis.new from: params[:from], to: params[:to]
    else
      @kpis = ::Admin::Kpis.new
    end

    render json: {kpis: @kpis.all}
  end

end
