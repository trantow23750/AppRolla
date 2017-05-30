module Acouchi
  class Which
    def self.find_executable name
      require "ptools"
      if executable = File.which(name)
        executable
      else
        raise %{Couldn't find any matches for the aliases "#{aliases.join(", ")}"}
      end
    end
  end
end
