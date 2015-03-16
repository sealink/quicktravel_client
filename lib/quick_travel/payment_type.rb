require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class PaymentType < Adapter
    attr_accessor :id,
                  :name,
                  :description,
                  :position,
                  :active,
                  :payment_method,
                  :for_frequent_traveller_redemption,
                  :notes,
                  :surchargeable,
                  :transaction_fee,
                  :credit_card_brand

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
  end
end
