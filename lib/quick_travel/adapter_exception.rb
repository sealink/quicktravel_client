module QuickTravel
  class AdapterError < StandardError
    attr_reader :response

    def initialize(response)
      @response = if response.is_a? String
                    { 'error' => response }
                  else
                    response.parsed_response
                  end

      error_message = @response.fetch('error', "We're sorry, but something went wrong. Please call us.")
      super(error_message)
    end

    def error_type
      @response.fetch('error_type', 'unspecified')
    end
  end
end
