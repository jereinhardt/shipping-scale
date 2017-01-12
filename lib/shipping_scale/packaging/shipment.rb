module ShippingScale
  class Shipment
    include Packable

    def initialize(packages)
      @packages = packages
    end

    def prices
      response.prices
    end
  end
end