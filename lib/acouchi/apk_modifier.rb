require "tmpdir"
require "securerandom"

module Acouchi
  class ApkModifier
    def initialize apk
      @apk = apk
      @output_path = "#{Dir.tmpdir}/#{SecureRandom.uuid}/"
    end

    def modify_manifest
      if block_given?
        decompile_apk
        manifest_path = File.join(@output_path, "AndroidManifest.xml")
        new_manifest = yield(File.read(manifest_path))
        File.open(manifest_path, "w") {|f| f.write(new_manifest)}
        compile_apk
        sign_apk_in_debug_mode
        overwrite_original_apk
      else
        throw "modify_manifest takes a block"
      end
    end

    private
      def decompile_apk
        ProcessLauncher.new(Executables.apktool, "d", @apk, @output_path).with_inherited_io.start_and_crash_if_process_fails
      end

      def compile_apk
        ProcessLauncher.new(Executables.apktool, "b", @output_path).with_inherited_io.start_and_crash_if_process_fails
      end

      def sign_apk_in_debug_mode
        @new_apk = File.join(@output_path, "dist", File.basename(@apk))
        jarsigner = Executables.jarsigner
        debug_keystore = File.join(ENV["HOME"], ".android", "debug.keystore")
        ProcessLauncher.new(
          jarsigner,
          "-keystore",
          debug_keystore,
          "-storepass",
          "android",
          "-keypass",
          "android",
          @new_apk,
          "androiddebugkey"
        ).with_inherited_io.start_and_crash_if_process_fails
      end

      def overwrite_original_apk
        FileUtils.mv(@new_apk, @apk)
      end
  end
end
