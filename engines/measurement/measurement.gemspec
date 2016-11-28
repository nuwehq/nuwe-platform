$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "measurement/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "measurement"
  s.version     = Measurement::VERSION
  s.authors     = ["Joost Baaij"]
  s.email       = ["joost@spacebabies.nl"]
  s.homepage    = "https://nuapi.co/"
  s.summary     = "Store measurements."
  s.description = "Store measurements."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "foreigner"
  s.add_dependency "active_model_serializers"

  # providers
  s.add_dependency "moves"
end
