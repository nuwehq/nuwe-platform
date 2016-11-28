# The only function of this controller is to return a status that we can ping.
# The status must travel through as much of the stack as possible.
class V1::StatusController < V1::BaseController

  # The response must utilize DB, search, and rendering (JSON).
  def show
    token = Token.find "65801fd1-3d94-4599-9d06-475b5ee01e28"
    render json: {gorby: token.user}
  end

end
