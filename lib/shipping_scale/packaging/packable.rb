module ShippingScale
  module Packable
    attr_accessor :response, :packages

    def get_response(options = {})
      ShippingScale::Request.config(options)
      @response = ShippingScale::Request.new(packages: packages).send!
    end

    def price
      @_price ||= response.nil? ? get_response.price : response.price
    end

    def details
      @_details ||= response.nil? ? response.details : get_response.details
    end
  end
end