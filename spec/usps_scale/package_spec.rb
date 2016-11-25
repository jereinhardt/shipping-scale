require "spec_helper"

describe USPSScale::Package do 
  let(:api_key) { "" }

  let(:attributes) do 
    {
      weight: 5,
      length: 1,
      width: 3,
      height: 5,
      zip_destination: "63501",
      zip_origin: "66204"
    }
  end

  before(:example) do 
    USPSScale::Client.configure do |config|
      config.api_user_id = api_key 
    end
  end

  describe "#initialize" do
    subject { USPSScale::Package.new(attributes) }

    it "sets @api_user_id passed down from the client" do
      key = subject.instance_variable_get("@api_user_id")

      expect(key).to eq(api_key)
    end

    it "sets attributes passed down from the client" do 
      expect(subject.attributes[:service]).to eq("Priority")
    end

    it "overrides attributes passed down from the client when arguments are given" do 
      service = "First Class Package"
      new_defaults = {service: service}
      new_attributes = attributes.merge(new_defaults)
      package = USPSScale::Package.new(new_attributes)

      expect(package.attributes[:service]).to eq(service)
    end

    it "sets package weight, length, width, height, zip origin, and zip dest." do 
      expect(subject.weight).to eq(attributes[:weight])
      expect(subject.length).to eq(attributes[:length])
      expect(subject.width).to eq(attributes[:width])
      expect(subject.height).to eq(attributes[:height])
      expect(subject.zip_destination).to eq(attributes[:zip_destination])
      expect(subject.zip_origin).to eq(attributes[:zip_origin])
    end
  end

  describe "#valid_zip_codes?" do 
    it "makes sure the zip destination and origin are valid" do 
      package = USPSScale::Package.new(attributes)

      expect(package.valid_zip_codes?).to be_truthy
    end

    it "returns falase when one or both zip codes are not valid" do
      new_attrs = attributes.merge({zip_origin: 1, zip_destination: 3})
      package = USPSScale::Package.new(new_attrs)

      expect(package.valid_zip_codes?).to be_falsey
    end
  end

  describe "#build_xml" do 
    subject { USPSScale::Package.new(attributes) }

    it "craeats an xml object" do 
      x = subject.build_xml(target: STDOUT, indent: 2)
      x
    end
  end

  describe "#send_request" do
    subject { USPSScale::Package.new(attributes.merge({api_user_id: ENV.fetch("USPS_USER_ID")})) }

    it "sends an xml request, and receives a valid response" do
    end
  end
end