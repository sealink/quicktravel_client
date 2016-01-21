require 'quick_travel/adapter'
require 'quick_travel/adjustment'
require 'quick_travel/resource'

module QuickTravel
  class Reservation < Adapter
    money :gross, :commission, :cost, :pre_adjusted_gross, :gross_including_packaged_item, :pre_adjusted_gross_including_packaged_item

    def self.create(options)
      json = post_and_validate('/api/reservations.json', options, expect: :json)
      new(json)
    end

    def self.destroy(id)
      delete_and_validate("/api/reservations/#{id}.json")
    end

    def adjustments
      @adjustments_attributes.map { |adjustment| Adjustment.new(adjustment) }
    end

    def resource
      @resource ||= QuickTravel::Resource.find(resource_id) if resource_id
    end

    def start_date_time
      start_time.to_time.on(first_travel_date) if start_time
    end

    def end_date_time
      end_time.to_time.on(last_travel_date) if end_time
    end

    def to_route_stop
      QuickTravel::RouteStop.new(@to_route_stop_attributes) if @to_route_stop_attributes
    end

    def from_route_stop
      QuickTravel::RouteStop.new(@from_route_stop_attributes) if @from_route_stop_attributes
    end

    # it send API request for Resource show. and cache the data.
    # i think now this method is not required because now booking show api call have display_text for every reservation
    def details
      if @_resource.blank?
        @_resource = Resource.find(@resource_id) unless @resource_id.blank?
      end
      @_resource
    end

    def sub_reservations
      @sub_reservations ||= Array(@sub_reservations_attributes).map do |attributes|
        Reservation.new(attributes)
      end
    end

    def passengers_count_string(booking)
      passengers_count(booking).join(', ')
    end

    def passengers_count(booking)
      passenger_type_count = {}
      if passenger_splits.present?
        passenger_splits.each do |p|
          passenger = booking.find_passenger_by_id(p['consumer_id'])

          if passenger.present?
            passenger_type_count[passenger.passenger_type_id] ||= 0
            passenger_type_count[passenger.passenger_type_id] += 1
          end
        end
      end
      PassengerType.passenger_counts(passenger_type_count)
    end

    def vehicle_count_string(booking)
      vehicles_count(booking).to_sentence
    end

    def vehicles_count(booking)
      vehicle_splits.map do|v|
        vehicle = booking.find_vehicle_by_id(v['consumer_id'])
        "#{vehicle.length}m #{vehicle.vehicle_type.name}"
      end
    end

    def duration
      (last_travel_date - first_travel_date + 1).to_i
    end

    def adjusted?
      pre_adjusted_gross_including_packaged_item != gross_including_packaged_item
    end
  end
end
