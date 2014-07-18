$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tincanz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tincanz"
  s.version     = Tincanz::VERSION
  s.authors     = ["Adam Akhtar"]
  s.email       = ["Adamsubscribe@googlemail.com"]
  s.homepage    = "https://github.com/robodisco/tincanz"
  s.summary     = "Segment and message users based on behaviour"
  s.description = "Tincanz is a poor mans intercom.io. It allows you to interact with your users from within your own app and schedule messages to be sent on predefined user behaviour."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.1"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'rspec-rails', '~>3.0.0'
  s.add_development_dependency 'capybara', '~>2.4.0'
  s.add_development_dependency 'devise', '~>3.2.0'
  s.add_development_dependency 'factory_girl_rails', '~>4.4.0'
end
