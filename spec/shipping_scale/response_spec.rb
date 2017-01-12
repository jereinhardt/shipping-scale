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
        t.tag!("Postage", CLASSID: "1") do |n|
          n.tag!("Name", "Priority First Class")
          n.tag!("Rate", "1.50")
        end
      end

      xml = Nokogiri::XML.parse(xml.body)

      details_hash = {
        mail_service: "First Class Mail",
        zip_origination: "66204",
        zip_destination: "63501",
        postage: [{name: "Priority First Class", rate: "1.50"}],
      }

      response = ShippingScale::Response.parse(xml)

      expect(response.details).to eq(details_hash)
    end
  end

  describe "#price" do
    it "returns the floating point value for the total price of postage" do
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Return") do |n|
        n.tag!("Package") do |t|
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "1.50")
          end
        end
        n.tag!("Package") do |t|
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "3.00")
          end
        end
      end
      xml = Nokogiri::XML.parse(xml.body)

      response = ShippingScale::Response.parse(xml)

      expect(response.price).to eq(4.5)
    end
  end

  describe "#prices" do
    it "returns individual prices for each package in the request" do 
      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Return") do |n|
        n.tag!("Package", ID: "1") do |t|
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "1.50")
          end
        end
        n.tag!("Package", ID: "2nd") do |t|
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "3.00")
          end
        end
      end
      xml = Nokogiri::XML.parse(xml.body)
      price_hash = {"1" => 1.5, "2nd" => 3.0} 

      response = ShippingScale::Response.parse(xml)
      prices = response.prices

      expect(prices).to eq(price_hash)
    end
  end
end