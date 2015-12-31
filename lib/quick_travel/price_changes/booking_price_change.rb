module QuickTravel
  module PriceChanges
    class BookingPriceChange < PriceChangeTree
      def initialize(attrs = {})
        super(
          attrs.merge(
            'root'     => attrs,
            'children' => attrs['reservation_price_changes']
          )
        )
      end

      def reservation_price_changes
        @children
      end

      def discounts
        price_changes.select(&:negative?)
      end

      def surcharges
        price_changes.select(&:positive?)
      end

      def price_changes
        @children.flat_map(&:roots)
      end
    end
  end
end
