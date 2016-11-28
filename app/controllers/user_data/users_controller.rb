class UserData::UsersController < UserData::BaseController

  def index
    @users = User.where(id: user_ids).page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end


  def parse
    @parse_class = params[:parse_class]
    data = ConnectParse.new(@application, @parse_class)
    response = {
      meta: data,
      schemas: data.schemas,
      parse: data.classes['results']
    }
    respond_to do |format|
      format.html
      format.json { render json: response }

    end
  end
end
