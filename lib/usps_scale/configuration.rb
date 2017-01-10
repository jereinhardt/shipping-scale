module USPSScale
  class Configuration < Struct.new(:user_id, :timeout, :testing, :zip_origin, :zip_destination)
    def initialize
      self.timeout = 5
      self.testing = false
      self.user_id = (ENV.fetch("USPS_USER_ID")) ? ENV.fetch("USPS_USER_ID") : nil
    end

    alias :testing? :testing
  end
end