require 'quick_travel/adapter'
require 'quick_travel/products/base'

module QuickTravel
  module Products
    class ScheduledTrip < Base
      belongs_to :to_route_stop, class_name: 'RouteStop'
      belongs_to :from_route_stop, class_name: 'RouteStop'

      @reservation_for_type = :scheduled_trips



      def from_route_stop_id
        return nil if from_route_stop.nil?

        from_route_stop.id
      end

      def to_route_stop_id
        return nil if to_route_stop.nil?

        to_route_stop.id
      end
    end
  end
end
