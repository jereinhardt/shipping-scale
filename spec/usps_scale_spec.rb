require "spec_helper"

describe USPSScale::Client do 
  describe "#configure" do 
    it "sets the api key as a class variable" do 
      key = "12345"
      USPSScale::Client.configure do |config|
        config.api_user_id = key
      end

      expect(USPSScale::Client.api_user_id).to eq(key)
    end
  end
end

describe USPSScale::Client do 
  let(:api_key) { "12345" }

  before(:example) do 
    USPSScale::Client.configure do |config|
      config.api_user_id = api_key 
    end
  end

  describe "#initialize" do 
    it "sets @api_user_id passed down from the client" do
      package = USPSScale::Package.new
      key = package.instance_variable_get("@api_user_id")

      expect(key).to eq(api_key)
    end
  end
end