require "spec_helper"

describe ShippingScale::Package do 
  subject { ShippingScale::Package }

  let(:package_options) do 
    { weight: 1.5, length: 3, width: 2, height: 3, zip_origination: "66204", zip_destination: "63501" }
  end

  describe ".shipment" do
    it "creates an shipment object to hold array of pakcages" do
      package2_options = { weight: 2.6, length: 5, width: 6, height: 5, zip_origination: "90415", zip_destination: "66120" }

      packages = [package_options, package2_options]
      shipment = subject.shipment(packages)

      package_zips = [
        subject.new(package_options),
        subject.new(package2_options)
      ].map(&:zip_destination)

      shipment_zips = shipment.packages.map(&:zip_destination)

      expect(shipment.is_a?(ShippingScale::Shipment)).to be true
      expect(shipment_zips).to match_array(package_zips)
    end
  end

  describe "#initialize" do 
    it "sets zip_destination and zip_origin to config variables if set" do 
      new_zip_dest = "94111"
      new_zip_origin = "54065"

      ShippingScale.configure do |config|
        config.zip_destination = new_zip_dest
        config.zip_origination = new_zip_origin
      end

      options = {weight: 1.5, length: 3, width: 2, height: 3}
      package = subject.new(options)

      expect(package.instance_variable_get("@zip_origination")).to eq(new_zip_origin)
      expect(package.instance_variable_get("@zip_destination")).to eq(new_zip_dest)        
    end
  end

  describe "#build_xml" do 
    it "builds a xml to represent package inside of existing xml data" do 
      package = subject.new(package_options)

      xml = Builder::XmlMarkup.new(indent: 0)


      request = xml.tag!('V4RATE', USERID: "0000") do |req|
        req.tag!("Package", ID: "1") do |pac| 
          pac.tag!("Service", "All")
          pac.tag!("Container", "VARAIBLE")
          pac.tag!("Size", "REGULAR")
          package_options.each { |k, v| pac.tag!(k.to_s, v) }
        end
      end

      package_request = xml.tag!('V4RATE', USERID: "0000") do |req|
        req.tag!("Package", ID: "1") do |pac|
          package.build_xml(pac)
        end
      end

      expect(request).to eq(package_request)
    end
  end

  describe "#get_price!" do 
    it "sends a request and returns a response" do
      package = subject.new(package_options)

      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Package") do |t| 
        t.tag!("Postage", CLASSID: "1") do |n|
          n.tag!("Rate", "15.00")
        end
      end
      allow(Typhoeus::Request).to receive(:get).and_return(xml)

      package.get_price!

      expect(package.price).to eq(15.0)
    end
  end
end