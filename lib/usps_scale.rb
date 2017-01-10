require "usps_scale/version"
require "builder"
require "nokogiri"
require "snakecase_string"

module USPSScale 

  autoload :Client,          "usps_scale/client"
  autoload :Configuration,   "usps_scale/configuration"
  autoload :Request,         "usps_scale/request"
  autoload :Response,        "usps_scale/response"
  autoload :Error,           "usps_scale/error"
  autoload :Package,         "usps_scale/package"

  class << self 
    attr_writer :config

    def client
      @client ||= Client.new
    end

    def testing=(val)
      config.testing = val
    end

    def config
      @config ||= Configuration.new
    end

    def configure(&block)
      block.call(self.config)
    end
  end
end
