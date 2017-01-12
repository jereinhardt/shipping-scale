module ShippingScale
  class Package
    include Packable

    class << self
      def shipment(details)
        packages = details.map { |package| new(package) }
        ShippingScale::Shipment.new(packages)
      end
    end

    attr_reader(
      :weight,
      :pounds,
      :ounces,
      :length,
      :width,
      :height,
      :zip_origination,
      :zip_destination,
    )

    def initialize(**options)
      @weight = options[:weight]
      @pounds = (options[:pounds]) ? options[:pounds] : get_pounds
      @ounces = (options[:ounces]) ? options[:ounces] : get_ounces
      @zip_origination = (options[:zip_origination]) ? options[:zip_origination] : ShippingScale.config.zip_origination 
      @zip_destination = (options[:zip_destination]) ? options[:zip_destination] : ShippingScale.config.zip_destination

      @packages = [self]
    end
    
    def build_xml(package) 
      attrs.each do |k, v| 
        package.tag!(k.to_s.upper_camelcase, v) 
      end
    end
    #TODO set methods to determin service, container, and size

    private

    def get_pounds
      @weight.floor.to_i
    end

    def get_ounces
      frac = @weight - @weight.floor
      ((frac * 16) / 10).ceil.to_i
    end

    def attrs
      {
        service: "All",
        zip_origination: @zip_origination,
        zip_destination: @zip_destination,
        pounds: @pounds,
        ounces: @ounces,
        container: "VARIABLE",
        size: "Regular",
        machinable: "true"
      }
    end
  end
end