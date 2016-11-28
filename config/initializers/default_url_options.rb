# Set default URL options.
#
# I don't really like this since we need to remember to change these options
# if one of the values changes. But, by defining these defaults our JSON
# serializer will always be able to serialize fully-qualified URLS in the API.
#
Rails.application.routes.default_url_options[:host] = "api.nuapi.co"
Rails.application.routes.default_url_options[:protocol] = "https"
