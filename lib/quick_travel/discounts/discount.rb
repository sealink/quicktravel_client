module QuickTravel
  module Discounts
    class Discount
      attr_reader :target
      attr_reader :original_price, :discounted_price, :discount, :reason

      def initialize(attrs = {})
        @target = OpenStruct.new(attrs.fetch('target').slice('id', 'type'))

        @original_price   = Money.new(attrs.fetch('original_price_in_cents'))
        @discounted_price = Money.new(attrs.fetch('discounted_price_in_cents'))
        @discount         = Money.new(attrs.fetch('discount_in_cents'))
        @reason           = attrs.fetch('reason')
      end

      def applied_on?(id, type = 'Reservation')
        @target.type == type && @target.id == id
      end
    end
  end
end
