require 'quick_travel/adapter'
require 'quick_travel/adjustment'
require 'quick_travel/resource'

module QuickTravel
  class Reservation < Adapter
    has_many :adjustments
    has_many :sub_reservations, class_name: 'Reservation'
    belongs_to :to_route_stop, class_name: 'RouteStop'
    belongs_to :from_route_stop, class_name: 'RouteStop'

    def self.create(options)
      json = post_and_validate('/api/reservations.json', options, expect: :json)
      new(json)
    end

    def self.destroy(id)
      delete_and_validate("/api/reservations/#{id}.json")
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

    def adjusted?
      pre_adjusted_gross_including_packaged_item != gross_including_packaged_item
    end
  end
end
