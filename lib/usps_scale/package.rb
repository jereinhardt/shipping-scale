module USPSScale
  class Package
    def initialize(options = {})
      @api_user_id = USPSScale::Client.api_user_id
    end
  end
end