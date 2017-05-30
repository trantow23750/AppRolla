module Acouchi
  class Executables
    def self.adb
      @adb ||= Which.find_executable("adb")
    end

    def self.jarsigner
      @jarsigner ||= Which.find_executable("jarsigner")
    end

    def self.apktool
      @apktool ||= Which.find_executable("apktool")
    end

    def self.ant
      @ant ||= Which.find_executable("ant")
    end
  end
end
