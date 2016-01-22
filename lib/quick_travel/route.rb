module QuickTravel
  class Route < Adapter
    attr_accessor :id, :name, :path, :position, :product_type_id, :reverse_id, :route_stops

    # find_by_id -- but the API only does lookup by product_type_id
    def self.find_by_route_id_and_product_type_id(route_id, product_type_id)
      all_by_route_ids_and_product_type_id([route_id.to_i], product_type_id).first
    end

    # Return routes that match the given ids and product_type_id
    #
    # Initializes with path set
    def self.all_by_route_ids_and_product_type_id(route_ids, product_type_id)
      all(product_type_id).select do|route|
        route_ids.include?(route.id.to_i)
      end
    end

    # All routes for a given product type
    def self.all(product_type_id)
      cache_key = "trip_routes_#{product_type_id}"
      routes = QuickTravel::Cache.cache_store.read(cache_key)

      if routes.blank? || !routes.first.instance_of?(Route) # this is hack for development env. Lazy loading is main issue with it.
        routes = self.find_all!("/product_types/#{product_type_id}/routes.json")
        QuickTravel::Cache.cache_store.write(
          cache_key,
          routes,
          expires_in: 1440.minutes # expires_in will only work with something like Rails.cache
        )
      end

      routes
    end

    def self.find(routes_list, route_id)
      routes_list.detect do|route|
        route.id.to_i == route_id.to_i
      end
    end

    def route_stops
      @_stops ||= @route_stops.map { |item| RouteStop.new(item) }
    end

    def get_return_route_stop!(forward_stop)
      if forward_stop.blank?
        fail AdapterError, 'Selected pick up/drop off stops have not been set up for the selected route.'
      end

      reverse_stop = get_reverse_route!.route_stops.detect { |route_stop| route_stop.name == forward_stop.name }

      if reverse_stop.blank?
        fail AdapterError, 'Selected pick up/drop off stops have not been setup on the reverse route.'
      end
      reverse_stop
    end

    def get_reverse_route!
      if reverse_id.blank?
        fail AdapterError, 'Reverse has not been setup for the selected route.'
      end

      reverse_route = Route.find_by_route_id_and_product_type_id(reverse_id, product_type_id)
      if reverse_route.blank?
        fail AdapterError, 'Reverse does not exist for the selected route.'
      end

      reverse_route
    end

    def find_route_stop_by_id(route_stop_id)
      route_stops.detect { |route_stop| route_stop.id.to_i == route_stop_id.to_i }
    end
  end
end
