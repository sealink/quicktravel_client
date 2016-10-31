module QuickTravel
  class AdapterError < StandardError
    attr_reader :response

    def initialize(response)
      @response = case response
                  when String
                    { 'error' => response }
                  when HTTParty::Response
                    response.parsed_response
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
