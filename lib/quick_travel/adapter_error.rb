module QuickTravel
  class AdapterError < StandardError
    attr_reader :response
    attr_reader :status

    def initialize(response)
      case response
        when String
          @response = { 'error' => response }
          @status = 422
        when HTTParty::Response
          @response = response.parsed_response
          @status = response.code
        else
          fail "Unexpected response type #{response.class}"\
               "Should be String or HTTParty::Response"
      end

      error_message = if @response.is_a? Hash
        @response.fetch('error', "We're sorry, but something went wrong. Please call us.")
      else
        @response
      end
      super(error_message)
    end

    def error_type
      @response.fetch('error_type', 'unspecified')
    end
  end
end
