require 'quick_travel/adapter'

module QuickTravel
  class BasicProduct < Adapter
    def to_route_stop
      RouteStop.new(@to_route_stop_attributes) if @to_route_stop_attributes
    end

    def from_route_stop
      RouteStop.new(@from_route_stop_attributes) if @from_route_stop_attributes
    end

    def from_route_stop_id
      return nil if from_route_stop.nil?

      from_route_stop.id
    end

    def to_route_stop_id
      return nil if to_route_stop.nil?

      to_route_stop.id
    end

    def normally_bookable?
      bookable || exception_type == 'inventory'
    end

    # Product.find_generic
    #
    #   Required: :product_type_id, :product (with sub-key :first_travel_date)
    #   Example:
    #     {
    #       product_type_id:       554881965,
    #       resource_category_id: nil,
    #       resource_id:           nil,
    #       location_id:           nil,
    #       region_id:             nil,
    #       product:               {
    #         first_travel_date: '14-04-2010',
    #         passenger_types: { "1" => nil, "2" => nil, "3" => nil, "4" => nil , "5" => nil },
    #         duration: nil,
    #         vehicle_types: {  },
    #         quantity: nil
    #       }
    #     }
    #
    # @return
    #   - Array of JSON objects matching the search criteria
    #   OR
    #   - An error string
    def self.find(type, search_params = {})
      url = "/reservation_for/#{type}/find_services_for.json"
      product_maps = post_and_validate(url, search_params)
      product_maps.map { |product_map| BasicProduct.new(product_map) }
    end
  end
end
