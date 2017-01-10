require "spec_helper"

describe USPSScale::Request do
  let(:package_options) do 
    { weight: 1.5, length: 3, width: 2, height: 3, zip_origin: "66204", zip_destination: "63501" }
  end

  let(:package) do 
    package = USPSScale::Package.new(package_options)
  end

  subject { USPSScale::Request.new(packages: [package]) }

  before(:example) { USPSScale::Request.config }

  describe ".config" do 
    it "sets class attributes with options given" do 
      options = {
        api: "RateV5",
        tag: "RateV4RequestNew",
        secure: true
      }

      req = USPSScale::Request
      req.config(options)

      expect(req.api).to eq(options[:api])
      expect(req.tag).to eq(options[:tag])
      expect(req.secure).to eq(options[:secure])
    end
  end

  describe "#build" do 
    it "creates an xml packet according to its configurations" do 
      xml = Builder::XmlMarkup.new(indent: 0)

      package_xml = xml.tag!('RateV4Request', USERID: "12345") do |req|
        req.tag!("Revision", "2")
        req.tag!("Package", ID: "1") do |pac| 
          pac.tag!("Service", "All")
          pac.tag!("Container", "VARAIBLE")
          pac.tag!("Size", "REGULAR")
          package_options.each { |k, v| pac.tag!(k.to_s, v) }
        end
      end

      request_xml = subject.build

      expect(request_xml).to eq(package_xml)
    end
  end

  describe "#send!" do 
    it "sends the request and returns the response object" do 
      return_xml = Builder::XmlMarkup.new(indent: 0)
      return_xml.tag!("Package") do |t| 
        t.tag!("Postage", "1.50")
      end
      allow(Typhoeus::Request).to receive(:get).and_return(return_xml)

      response = subject.send!

      expect(response.is_a?(USPSScale::Response)).to be true
      expect(response.price).to eq(1.5)
    end
  end
end