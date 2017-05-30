require "cucumber"
require "cucumber/rake/task"
require "acouchi"
require "acouchi/rspec/matchers"

desc "build project with Acouchi code included"
task :build do
  configuration = Acouchi::Configuration.from_json(File.read("acouchi_configuration.json"))
  configuration.device =ENV["ACOUCHI_DEVICE"] if ENV["ACOUCHI_DEVICE"]
  configuration.port =ENV["ACOUCHI_PORT"] if ENV["ACOUCHI_PORT"]
  Acouchi::ProjectBuilder.new(configuration).build
end

desc "farm"
task :farm do
  port_range = (7004...10000).to_a
  %x(adb devices).scan(/.*\tdevice/).map{|device|device.gsub! "	device",""}.each do |device|
    system "ACOUCHI_DEVICE=#{device} ACOUCHI_PORT=#{port_range.sample} rake features &"
  end
end

desc "open up an acouchi console"
task :console do
  configuration = Acouchi::Configuration.from_json(File.read("acouchi_configuration.json"))
  configuration.device =ENV["ACOUCHI_DEVICE"] if ENV["ACOUCHI_DEVICE"]
  configuration.port =ENV["ACOUCHI_PORT"] if ENV["ACOUCHI_PORT"]
  test_runner = Acouchi::TestRunner.new(configuration)
  test_runner.start
  page = Acouchi::Solo.new(configuration)
  require "pry"
  binding.pry
  test_runner.stop
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress --format html --out=#{ENV["ACOUCHI_DEVICE"]}.html"
end
