require "spec_helper"

describe ShippingScale::Client do
  subject { ShippingScale::Client.new }

  before(:each) do 
    ShippingScale.configure { |c| c.testing = true }
  end
  
  describe "#request" do

    it "sends an xml request to the USPS API server and receives a response" do
      ShippingScale::Request.config

      return_xml = Builder::XmlMarkup.new(indent: 0)
      return_xml.tag!("Package") do |xml|
        xml.tag!("Postage", "1.50")
      end

      request = instance_double("ShippingScale::Request")
      allow(request).to receive(:secure?).and_return(false)
      allow(request).to receive(:api).and_return("RateV4")
      allow(request).to receive(:build)
      allow(Typhoeus::Request).to receive(:get).and_return(return_xml)

      response = subject.request(request)

      expect(response.is_a?(ShippingScale::Response)).to be true
      expect(response.price).to eq(1.5)
    end

    it "returns the propper error based on data" do 
      return_xml = Builder::XmlMarkup.new(indent: 0)
      return_xml.tag!("Error") do |xml|
        xml.tag!("Description", "Invalid Zip Destination")
        xml.tag!("Number", "-2147219497")
        xml.tag!("Source", "Zip Code")
      end

      request = instance_double("ShippingScale::Request")
      allow(request).to receive(:secure?).and_return(false)
      allow(request).to receive(:api).and_return("RateV4")
      allow(request).to receive(:build)

      allow(Typhoeus::Request).to receive(:get).and_return(return_xml)

      expect{ subject.request(request) }.to raise_error(ShippingScale::InvalidZipDestinationError)
    end
  end

  describe "#testing?" do 
    it "returns bool based on the configuration of ShippingScale object" do 
      ShippingScale.testing = true

      expect(subject.testing?).to be true
    end
  end

  describe "#server" do 
    it "returns a secure path when the request is secure" do 
      secure_path = "https://secure.shippingapis.com/ShippingAPI.dll"
      ShippingScale::Request.config(secure: true)
      ShippingScale.testing = false

      server = subject.server(ShippingScale::Request.new)
      expect(server).to eq(secure_path)
    end

    it "returns a testing path when in a testing evironment" do 
      test_path = "http://testing.shippingapis.com/ShippingAPI.dll"
      ShippingScale::Request.config(secure: false)
      ShippingScale.testing = true

      server = subject.server(ShippingScale::Request.new)
      expect(server).to eq(test_path)
    end

    it "returns the production path when not secure or in testing" do 
      prod_path = "http://production.shippingapis.com/ShippingAPI.dll"
      ShippingScale::Request.config(secure: false)
      ShippingScale.testing = false

      server = subject.server(ShippingScale::Request.new)
      expect(server).to eq(prod_path)
    end
  end
end