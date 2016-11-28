$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nutrition/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nutrition"
  s.version     = Nutrition::VERSION
  s.authors     = ["Melanie"]
  s.email       = ["melanie@spacebabies.nl"]
  s.homepage    = "http://www.spacebabies.nl"
  s.summary     = "Nutrition engine"
  s.description = "An engine for nutrition"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "foreigner"
  s.add_dependency "active_model_serializers"
end
