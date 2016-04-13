require 'quick_travel/adapter'
require 'quick_travel/base_product'

module QuickTravel
  class ScheduledTripProduct < BaseProduct
    @reservation_for_type = :scheduled_trips

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
  end
end
