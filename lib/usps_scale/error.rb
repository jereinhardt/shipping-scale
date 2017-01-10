module USPSScale
  class Error < StandardError
    attr_reader :code, :source

    def initialize(message, code, source)
      super(message)

      @code = code
      @source = source
    end

    class << self 
      def for_code(code)
        case code 
        when "-2147219498"    ; AuthorizationError
        when "-2147219100"    ; MissingZipOriginError
        when "-2147219099"    ; MissingZipDestinationError
        when "-2147219497"    ; InvalidZipDestinationError
        when "-2147219498"    ; InvalidZipOriginError
        when "-2147219097"    ; MissingWeightError
        when "-2147219098"    ; MissingWeightError
        else                  ; Error
        end
      end
    end
  end

  class AuthorizationError < Error; end

  class ValidationError < Error; end
  class InvalidZipOriginError < ValidationError; end
  class InvalidZipDestinationError < ValidationError; end
  class MissingZipOriginError < ValidationError; end
  class MissingZipDestinationError < ValidationError; end
  class MissingWeightError < ValidationError; end
end