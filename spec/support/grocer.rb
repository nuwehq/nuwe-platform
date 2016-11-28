require 'timeout'

class GrocerServer
  include Singleton

  def server
    Grocer.server(port: 2195)
  end
end
