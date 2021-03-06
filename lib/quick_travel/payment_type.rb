require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class PaymentType < Adapter
    self.api_base = '/payment_types'
    self.lookup = true

    def credit_card
      payment_method == 'credit_card'
    end

    def code
      if credit_card
        credit_card_brand.underscore.gsub(/\s/, '_')
      else
        payment_method
      end
    end

    def as_json(options = nil)
      super.merge(code: code)
    end

    def self.information
      get_and_validate('/api/payment_types/information.json')
    end
  end
end
