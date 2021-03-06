$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "robinhood_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "robinhood_rails"
  s.version     = RobinhoodRails::VERSION
  s.authors     = ["Nemrow"]
  s.email       = ["nemrowj@gmail.com"]
  s.homepage    = "https://github.com/nemrow/robinhood_rails"
  s.summary     = "Access robinhood free trading stock platform via API"
  s.description = "Access robinhood free trading stock platform via API"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
  s.add_dependency 'httparty'
end
