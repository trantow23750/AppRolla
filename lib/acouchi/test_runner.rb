module Acouchi
  class TestRunner
    def initialize configuration
      @configuration = configuration
    end

    def start

      apk_installer = ApkInstaller.new(@configuration)
      apk_installer.uninstall_apk
      apk_installer.install_apk 


      if @configuration.device
        ProcessLauncher.new(Executables.adb,"-s",@configuration.device, "forward", "tcp:#{@configuration.port}", "tcp:7103").start_and_crash_if_process_fails
        @test_runner_process = ProcessLauncher.new(Executables.adb, "-s" ,@configuration.device, "shell", "am", "instrument", "-w", "#{@configuration.target_package}/android.test.InstrumentationTestRunner")
      else
        ProcessLauncher.new(Executables.adb, "forward", "tcp:#{@configuration.port}", "tcp:7103").start_and_crash_if_process_fails
        @test_runner_process = ProcessLauncher.new(Executables.adb, "shell", "am", "instrument", "-w", "#{@configuration.target_package}/android.test.InstrumentationTestRunner")
      end

      @test_runner_process.start_in_background

      sleep 0.1 until ready?
    end

    def stop
      HTTParty.get("http://127.0.0.1:#{@configuration.port}/finish") rescue nil
    end

    private
      def ready?
        HTTParty.get("http://127.0.0.1:#{@configuration.port}/").body == "Acouchi" rescue false
      end
  end
end
