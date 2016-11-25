module USPSScale
  class Package
    include GoingPostal

    def initialize(options={})
      @api_user_id = USPSScale::Client.api_user_id
      @attributes = USPSScale::Client.defaults.merge(options)
      @weight = attributes[:weight]
      @length = attributes[:length]
      @width = attributes[:width]
      @height = attributes[:height]
      @zip_origin = attributes[:zip_origin].to_s
      @zip_destination = attributes[:zip_destination].to_s
      build_xml
    end
    
    attr_reader(
      :attributes,
      :weight,
      :length,
      :width,
      :height,
      :zip_origin,
      :zip_destination
    )

    def valid_zip_codes?
      postcode?(zip_destination, "US") &&
        postcode?(zip_origin, "US")
    end

    def build_xml(options={})
      special_keys = [:weight, :content]
      @xml = Builder::XmlMarkup.new(options)

      @xml.RateV4Request(USERID: @api_user_id) do |request|
        request.Revision(2)
        request.Package(ID: 1) do |package|
          attributes.select {|k, v| !special_keys.include?(k) }.each do |name, value|
            var = name.to_s.split("_").collect(&:capitalize).join
            package.send("#{var}", value)
          end
          package.Pounds(pounds)
          package.Ounces(ounces)
          package.Size(size)
          # TODO: deal with <Content> tags
        end
      end
    end

    def send_request
    end

    private 

    def pounds
      @weight.floor
    end

    def ounces
      frac = @weight - @weight.floor
      (frac == 0) ? frac : (16/frac).ceil
    end

    def dimensions
      [@length, @width, @height]
    end

    def size
      if dimensions.any? { |d| d > 12 }
        "Regular"
      else
        "Large"
      end
    end
  end
end