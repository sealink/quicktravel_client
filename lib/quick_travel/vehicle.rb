require 'quick_travel/adapter'

module QuickTravel
  class Vehicle < Adapter
    def self.create(booking_id, vehicle_types = {})
      options = { booking_id: booking_id, vehicle_types: vehicle_types }
      response = post_and_validate("#{Booking.front_office_base}/#{booking_id}/vehicles.json", options)
      fail AdapterError.new(response) unless response.key?('booking_id')
    end

    def vehicle_type
      VehicleType.all.detect { |vt| vt.id == vehicle_type_id }
    end
  end
end
