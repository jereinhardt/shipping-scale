require "spec_helper"

describe ShippingScale::Shipment do 
  subject { ShippingScale::Shipment }

  let(:packages) do 
    [ 
      ShippingScale::Package.new(weight: 1.5, zip_origination: "66204", zip_destination: "63501"),
      ShippingScale::Package.new(weight: 1.5, zip_origination: "66204", zip_destination: "63501")
    ]
  end

  describe "#get_price!" do 
    it "sends a request and returns a response" do
      shipment = subject.new(packages)

      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Response") do |r|
        r.tag!("Package") do |t| 
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "15.00")
          end
        end
        r.tag!("Package") do |t| 
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "10.00")
          end
        end
      end

      allow(Typhoeus::Request).to receive(:get).and_return(xml)

      shipment.get_price!

      expect(shipment.price).to eq(25.0)
    end
  end

  describe "#prices" do 
    it "returns a hash of prices for each package" do
      shipment = subject.new(packages)

      xml = Builder::XmlMarkup.new(indent: 0)
      xml.tag!("Response") do |r|
        r.tag!("Package", ID: "1") do |t| 
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "15.00")
          end
        end
        r.tag!("Package", ID: "2nd") do |t| 
          t.tag!("Postage", CLASSID: "1") do |n|
            n.tag!("Rate", "10.00")
          end
        end
      end

      allow(Typhoeus::Request).to receive(:get).and_return(xml)

      shipment.get_price!

      prices_hash = {"1" => 15.0, "2nd" => 10.0}

      expect(shipment.prices).to eq(prices_hash)
    end
  end
end