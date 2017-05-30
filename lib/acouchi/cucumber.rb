Before do
  Acouchi::Cucumber.before
end

After do
  Acouchi::Cucumber.after
end

module Acouchi
  module Cucumber
    def self.page
      @page
    end

    def self.before
      @test_runner = TestRunner.new(@configuration)
      @test_runner.start
      @page = Solo.new(@configuration)
    end

    def self.after
      @test_runner.stop
    end

    def self.prepare configuration
      @configuration = configuration
    end
  end
end
