$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nu"
  s.version     = Nu::VERSION
  s.authors     = ["Joost Baaij"]
  s.email       = ["joost@spacebabies.nl"]
  s.homepage    = "http://nuwellness.co"
  s.summary     = "Calculate and store nu scores."
  s.description = "Calculate and store nu scores."

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "foreigner"
end
