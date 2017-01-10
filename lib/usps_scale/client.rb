require "typhoeus"

module USPSScale
  class Client
    def request(request)
      server = server(request)

      response = Typhoeus::Request.get(server, {
        timeout: USPSScale.config.timeout,
        params: {
          "API" => request.api,
          "XML" => request.build
        }
      })

      xml = Nokogiri::XML.parse(response.body)

      if ((error = xml.search('Error')).any?)
        why = error.search("Description").children.first
        code = error.search("Number").children.first.to_s
        source = error.search("Source").children.first
        raise USPSScale::Error.for_code(code).new(why, code, source)
      end

      USPSScale::Response.parse(xml)
    end

    def testing?
      USPSScale.config.testing?
    end

    def server(request)
      case 
      when request.secure? 
        "https://secure.shippingapis.com/ShippingAPI.dll"
      when testing?
        "http://testing.shippingapis.com/ShippingAPI.dll"
      else
        "http://production.shippingapis.com/ShippingAPI.dll"
      end
    end
  end
end