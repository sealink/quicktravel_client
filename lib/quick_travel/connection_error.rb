module QuickTravel
  class ConnectionError < Exception
    attr_reader :original
    def initialize(msg, original = $ERROR_INFO)
      super(msg)
      @original = original
    end
  end
end
