module QuickTravel
  module PriceChanges
    class PriceChange
      attr_reader :target
      attr_reader :original_price, :changed_price, :price_change, :reason, :reasons

      delegate :positive?, :negative?, to: :price_change

      def initialize(attrs = {})
        @target = OpenStruct.new(attrs.fetch('target').slice('id', 'type'))

        @original_price = Money.new(attrs.fetch('original_price_in_cents'))
        @changed_price  = Money.new(attrs.fetch('changed_price_in_cents'))
        @price_change   = Money.new(attrs.fetch('price_change_in_cents'))
        @reason         = attrs.fetch('reason')
        @reasons        = attrs.fetch('reasons', [@reason])
      end

      def applied_on?(id, type = 'Reservation')
        @target.type == type && @target.id == id
      end
    end
  end
end
