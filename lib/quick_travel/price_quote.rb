require 'quick_travel/adapter'

module QuickTravel
  class PriceQuote < Adapter
    self.api_base = '/api/price_quotes'

    def self.calculate(params)
      response = post_and_validate("#{api_base}/calculate", params)
      new(response)
    end
  end
end