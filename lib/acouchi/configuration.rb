module Acouchi
  class Configuration
    attr_accessor :target_package, :activity, :project_path, :apk,:device,:port

    def self.from_json json
      require "json"
      json = JSON.parse(json)
      configuration = Configuration.new
      configuration.target_package = json["target_package"]
      configuration.activity       = json["activity"]
      configuration.project_path   = json["project_path"]
      configuration.apk            = json["apk"]
      configuration.device         = json["device"]
      configuration.port           = json["port"] || 7103
      configuration
    end
  end
end
