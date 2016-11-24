module USPSScale
  class Client
    class << self 
      def configure(&block)
        if block_given?
          yield(self)
        end
      end

      attr_accessor :api_user_id
    end
  end
end