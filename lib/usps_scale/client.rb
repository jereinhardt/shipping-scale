module USPSScale
  class Client
    class << self 
      def configure(&block)
        if block_given?
          yield(self)
        end
      end

      attr_accessor :api_user_id

      def defaults
        {
          service: "Priority",
          container: "Variable"
        }
      end
    end
  end
end