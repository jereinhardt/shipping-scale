require "spec_helper"

describe ShippingScale::Response do 
  subject { ShippingScale::Response }
  describe ".parse" do 
    it "returns a new Response object" do 
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("XML") do |pac|
        pac.tag!("inner_value", "value")
      end

      response = subject.parse(xml)
      expect(response.instance_of?(subject)).to be true
    end

    it "allows for reading of raw xml on the instance" do
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("XML") do |pac|
        pac.tag!("inner_value", "value")
      end

      response = subject.parse(xml)
      expect(response.raw).to eq(xml)
    end
  end

  describe "#details" do
    it "returns a hash of all the xml nodes returned" do 
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Package") do |t|
        t.tag!("MailService", "First Class Mail")
        t.tag!("ZipOrigination", "66204")
        t.tag!("ZipDestination", "63501")
        t.tag!("Postage", "1.50")
      end
      xml = Nokogiri::XML.parse(xml)

      details_hash = {
        mail_service: "First Class Mail",
        zip_origination: "66204",
        zip_destination: "63501",
        postage: "1.50",
      }

      response = ShippingScale::Response.parse(xml)

      expect(response.details).to eq(details_hash)
    end
  end

  describe "#price" do
    it "returns the floating point price of postage" do
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Package") do |t|
        t.tag!("Postage", "1.50")
      end
      xml = Nokogiri::XML.parse(xml)

      response = ShippingScale::Response.parse(xml)

      expect(response.price).to eq(1.5)
    end
  end
end