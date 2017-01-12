module ShippingScale
  class Request
    class << self
      attr_reader :api, :tag, :secure

      def config(options = {})
        defaults = {api: "RateV4", tag: "RateV4Request"}
        options = defaults.merge(options)

        @api = options[:api]
        @tag = options[:tag]
        @secure = !!options[:secure]
      end
    end

    def initialize(options={})
      @response = options[:response]
      @packages = options[:packages]
    end

    attr_accessor :response
    attr_reader :packages

    def secure?
      !!self.class.secure
    end

    def api
      self.class.api
    end

    def build
      xml.tag!(self.class.tag, USERID: ShippingScale.config.user_id) do |req|
        req.tag!("Revision", "2")
        packages_to_xml(req)
      end
      xml
    end

    def send!
      ShippingScale.client.request(self)
    end

    private 

    def packages_to_xml(xml)
      i = 1
      packages.each do |package|
        xml.tag!("Package", ID: i) { |pac| package.build_xml(pac) }
        i += 1
      end
    end

    def xml
      @_xml ||= Builder::XmlMarkup.new(indent: 0)
    end
  end
end