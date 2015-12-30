module QuickTravel
  module PriceChanges
    class PriceChangeTree < PriceChange
      attr_reader :root, :children

      def initialize(attrs = {})
        super(attrs)
        @root     = PriceChange.new(attrs['root'])
        @children = attrs.fetch('children', []).map do |child_attrs|
          PriceChangeTree.new(child_attrs)
        end
      end

      def price_change_on(id, type = 'Reservation')
        return @root if applied_on?(id, type)
        find_and_return_on_children { |child| child.price_change_on(id, type) }
      end

      def total_price_change_on(id, type = 'Reservation')
        return self if applied_on?(id, type)
        find_and_return_on_children { |child| child.total_price_change_on(id, type) }
      end

      def roots
        [@root] + @children.flat_map(&:roots)
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
