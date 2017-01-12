module ShippingScale
  class Packaging
    attr_accessor :response, :packages

    def get_price!(options = {})
      ShippingScale::Request.config(options)
      @response = ShippingScale::Request.new(packages: packages).send!     
    end

    def price
      response.price
    end

    def details
      response.details
    end
  end
end