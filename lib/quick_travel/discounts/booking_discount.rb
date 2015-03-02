module QuickTravel
  module Discounts
    class BookingDiscount < DiscountTree
      def initialize(attrs = {})
        super(
          attrs.merge(
            'root'     => attrs,
            'children' => attrs['reservation_discounts']
          )
        )
      end

      def reservation_discounts
        @children
      end
    end
  end
end
