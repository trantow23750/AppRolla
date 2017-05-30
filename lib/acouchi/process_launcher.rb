require "childprocess"

module Acouchi
  class ProcessLauncher
    DEFAULT_START_OPTIONS = {:inherit_io => true}

    def initialize(*arguments)
      @arguments = arguments
      @process = ChildProcess.build(*@arguments)
      self
    end

    def with_inherited_io
      @process.io.inherit!
      self
    end

    def start
      @process.start
      self
    end

    def wait
      @process.wait
      self
    end

    def start_in_background
      @process.start
      self
    end

    def start_and_crash_if_process_fails
      start.wait
      if @process.crashed?
        raise "A process exited with a non-zero exit code.\nThe command executed was \"#{@arguments.join(" ")}\""
      end
      self
    end
  end
end
