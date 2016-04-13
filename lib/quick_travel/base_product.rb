require 'quick_travel/adapter'

module QuickTravel
  class BaseProduct < Adapter
    def normally_bookable?
      bookable || exception_type == 'inventory'
    end

    def self.find(search_params = {})
      find_for_type(@reservation_for_type, search_params)
    end

    def self.find_for_type(type, search_params = {})
      url = "/reservation_for/#{type}/find_services_for.json"
      product_maps = post_and_validate(url, search_params)
      product_maps.map { |product_map| new(product_map) }
    end
  end
end
