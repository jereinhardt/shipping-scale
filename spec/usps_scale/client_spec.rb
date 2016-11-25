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