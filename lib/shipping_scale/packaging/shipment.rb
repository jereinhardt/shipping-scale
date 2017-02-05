module ShippingScale
  class Shipment
    include Packable

    def initialize(packages)
      @packages = packages
    end

    def prices
      @_prices ||= response.nil? ? get_response.prices : response.prices
    end
  end
end