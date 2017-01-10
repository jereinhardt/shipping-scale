require "spec_helper"

describe USPSScale::Configuration do
  describe "#initialize" do
    it "sets default configurations" do
      config = USPSScale.config

      expect(config.timeout).to eq(5)
      expect(config.testing).to eq(false)
      expect(config.user_id).to eq(ENV.fetch("USPS_USER_ID"))
    end
  end

  describe "#configure" do 
    it "sets configuration values passed in" do 
      user_id = "12345"
      timeout = 10
      testing = true
      zip_origin = "66204"
      zip_destination = "63501"

      USPSScale.configure do |config|
        config.user_id = user_id
        config.timeout = timeout
        config.testing = testing
        config.zip_origin = zip_origin
        config.zip_destination = zip_destination
      end

      configurations = USPSScale.config

      expect(configurations.user_id).to eq(user_id)
      expect(configurations.timeout).to eq(timeout)
      expect(configurations.testing).to eq(testing)
      expect(configurations.zip_origin).to eq(zip_origin)
      expect(configurations.zip_destination).to eq(zip_destination)
    end
  end

  describe "#testing=" do 
    it "sets the testing enviornment" do 
      config = USPSScale.config
      USPSScale.testing = true

      expect(USPSScale.config.testing).to be true
    end
  end
end