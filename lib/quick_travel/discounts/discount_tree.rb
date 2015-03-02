module QuickTravel
  module Discounts
    class DiscountTree < Discount
      attr_reader :root, :children

      def initialize(attrs = {})
        super(attrs)
        @root     = Discount.new(attrs['root'])
        @children = attrs.fetch('children', []).map do |child_attrs|
          DiscountTree.new(child_attrs)
        end
      end

      def discount_on(id, type = 'Reservation')
        return @root if applied_on?(id, type)
        find_and_return_on_children { |child| child.discount_on(id, type) }
      end

      def total_discount_on(id, type = 'Reservation')
        return self if applied_on?(id, type)
        find_and_return_on_children { |child| child.total_discount_on(id, type) }
      end

      private

      def find_and_return_on_children(&block)
        @children.each do |child|
          result = block.call(child)
          return result unless result.nil?
        end
        nil
      end
    end
  end
end
