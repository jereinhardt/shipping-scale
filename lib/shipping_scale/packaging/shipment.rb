module ShippingScale
  class Shipment < Packaging
    def initialize(packages)
      @packages = packages
    end

    def prices
      response.prices
    end
  end
end