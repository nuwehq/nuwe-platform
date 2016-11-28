require 'httparty'

class ConnectParse

  include HTTParty
  default_timeout 7

  base_uri 'https://parse.YOURSITE.com:'

  def initialize(application, classes)
    @parse_app = application.parse_app
    @classes = classes
  end

  def schemas
    self.class.get("#{@parse_app.port}/parse/schemas", headers)
  end

  def classes
    self.class.get("#{@parse_app.port}/parse/classes/#{@classes}", headers)
  end

  private

  def headers
    {
      headers: {"X-Parse-Application-Id" => @parse_app.app_id, "X-Parse-Master-Key" => @parse_app.master_key, "Content-Type" => 'application/json'}
    }
  end

end
