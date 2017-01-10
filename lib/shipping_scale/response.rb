module ShippingScale
  class Response
    attr_accessor :raw

    class << self
      def parse(xml)
        response = self.new(xml)
        response.raw = xml
        response
      end
    end

    def initialize(xml)
      @xml = xml
    end

    attr_reader :xml

    def details
      details = {}

      xml.search("Package").children.each do |node|
        details[node.name.snakecase.to_sym] = node.text
      end

      return details
    end

    def price
      xml.search("Package").children.search("Postage").text.to_f
    end
  end
end