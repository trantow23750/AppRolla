require "acouchi"
require "acouchi/cucumber"
require "acouchi/rspec/matchers"

configuration = Acouchi::Configuration.from_json(File.read("acouchi_configuration.json"))
configuration.device =ENV["ACOUCHI_DEVICE"] if ENV["ACOUCHI_DEVICE"]
configuration.port =ENV["ACOUCHI_PORT"] if ENV["ACOUCHI_PORT"]

Acouchi::Cucumber.prepare(configuration)

def page
  Acouchi::Cucumber.page
end