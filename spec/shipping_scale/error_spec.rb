require "spec_helper"

describe ShippingScale::Error do 
  subject { ShippingScale::Error }

  describe "#initialize" do 
    it "#sets attributes based on error given" do
      error_code = "-2147219498"
      source = "DomesticRatesV4;RateEngineV4.ProcessRequest"
      message = "Please enter a valid ZIP Code for the sender."

      error = subject.new(message, error_code, source)

      expect(error.code).to eq(error_code)
      expect(error.source).to eq(source)
    end
  end

  describe "#self.for_code" do 
    let(:message) { "error message" }
    let(:source) { "error source" }

    it "raises an InvalidZipError when auth error is given" do 
      code = "-2147219497"

      expect { raise subject.for_code(code).new(message, code, source) }.to raise_error(ShippingScale::InvalidZipDestinationError)
    end

    it "raises an AuthorizationError when zip error is given" do 
      code = "-2147219498"

      expect { raise subject.for_code(code).new(message, code, source) }.to raise_error(ShippingScale::AuthorizationError)
    end

    # TODO: Get other error codes 
  end
end