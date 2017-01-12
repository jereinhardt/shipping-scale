require "shipping_scale/version"
require "builder"
require "nokogiri"
require "string_module"
require "typhoeus"


module ShippingScale 

  autoload :Client,          "shipping_scale/client"
  autoload :Configuration,   "shipping_scale/configuration"
  autoload :Error,           "shipping_scale/error"
  autoload :Package,         "shipping_scale/packaging/package"
  autoload :Packable,        "shipping_scale/packaging/packable"
  autoload :Request,         "shipping_scale/request"
  autoload :Response,        "shipping_scale/response"
  autoload :Shipment,        "shipping_scale/packaging/shipment"

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
