# The only function of this controller is to return a status that we can ping.
# The status must travel through as much of the stack as possible.
class V3::StatusController < V3::BaseController

  skip_after_filter :create_stat

  # The response must utilize DB, search, and rendering (JSON).
  def show
    token = Doorkeeper::AccessToken.find_by_token "585ac82a496805823b33459555c7eb2ef19f39fe55ab6e1aedd14be962e10c8a"
    render json: { gorby: token }
  end

end
