require 'quick_travel/adapter'

module QuickTravel
  module Products
    class Base < Adapter
      def normally_bookable?
        bookable || exception_type == 'inventory'
      end

      def self.find(search_params = {}, opts = {})
        find_for_type(@reservation_for_type, search_params, opts)
      end

      def self.find_for_type(type, search_params = {}, opts = {})
        url = "/reservation_for/#{type}/find_services_for.json"
        product_maps = post_and_validate(url, search_params, opts)
        product_maps.map { |product_map| new(product_map) }
      end
    end
  end
end
