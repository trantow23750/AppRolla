module Acouchi
  class ApkInstaller
    def initialize configuration
      @configuration = configuration
      @apk_path = File.join(configuration.project_path, "bin", configuration.apk)
    end

    def install_apk
      if @configuration.device
        ProcessLauncher.new(Executables.adb,"-s",@configuration.device,"install",@apk_path).start_and_crash_if_process_fails
      else
        ProcessLauncher.new(Executables.adb,"install",@apk_path).start_and_crash_if_process_fails
      end
    end

    def uninstall_apk
      if @configuration.device
        ProcessLauncher.new(Executables.adb,"-s",@configuration.device,"uninstall",@configuration.target_package).start
      else 
        ProcessLauncher.new(Executables.adb,"uninstall",@configuration.target_package).start
      end
    end
  end
end
