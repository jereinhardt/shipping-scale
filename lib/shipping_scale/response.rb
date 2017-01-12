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
      details = {postage: []}

      xml.search("Package").children.each do |node|
        if node.name == "Postage"
          postage = {}
          node.children.each do |child|
            postage[child.name.to_s.snakecase.to_sym] = child.text
          end
          details[:postage].push(postage)
        else
          details[node.name.to_s.snakecase.to_sym] = node.text
        end
      end

      return details
    end

    def price
      xml.search("Postage[CLASSID='1']").search("Rate").inject(0) { |sum, t| sum + t.text.to_f }
    end

    def prices
      prices = {}
      xml.search("Package").each do |package|
        key = package.attribute("ID").value.to_s
        value = package.search("Postage[CLASSID='1']").search("Rate").text.to_f
        prices[key] = value
      end

      prices
    end
  end
end