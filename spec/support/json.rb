require 'json'

# Parse a http response as JSON.
def json_body
  JSON.parse(response.body)
end
