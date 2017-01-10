require "spec_helper"

describe USPSScale::Package do 
  subject { USPSScale::Package }

  let(:package_options) do 
    { weight: 1.5, length: 3, width: 2, height: 3, zip_origin: "66204", zip_destination: "63501" }
  end

  describe "initialize" do 
    it "sets zip_destination and zip_origin to config variables if set" do 
      new_zip_dest = "94111"
      new_zip_origin = "54065"

      USPSScale.configure do |config|
        config.zip_destination = new_zip_dest
        config.zip_origin = new_zip_origin
      end

      options = {weight: 1.5, length: 3, width: 2, height: 3}
      package = subject.new(options)

      expect(package.instance_variable_get("@zip_origin")).to eq(new_zip_origin)
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
      xml.tag!("Package") { |t| t.tag!("Postage", "15.00") }
      allow(Typhoeus::Request).to receive(:get).and_return(xml)

      response = package.get_price!

      expect(response.price).to eq(15.0)
    end
  end
end