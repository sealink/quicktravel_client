require 'spec_helper'
require 'quick_travel/booking'

describe QuickTravel::Booking do
  before do
    @booking = nil
    QuickTravel.config.version = 3
    VCR.use_cassette('booking_create_legacy') do
      @booking = QuickTravel::Booking.create
    end
  end

  it 'booking.accommodation_reserve should return updated booking object that includes newly reserved accommodation with correct passenger_ids' do
    # this method will create new passenger_ids if not exits otherwise give the ids of existing passenger_ids from same booking
    passenger_ids =  @booking.find_or_create_passenger_ids('1' => 1)

    option = { first_travel_date: (Date.today + 35).strftime('%d-%m-%Y'),
               passenger_ids: passenger_ids, vehicle_ids: { '' => nil },
               bed_configuration_id: 988,
               resource_id: 1051
    }
    option[:passenger_types] = { '1' => nil, '2' => nil, '3' => nil, '4' => nil, '5' => nil }
    option[:last_travel_date] = (Date.today + 36).strftime('%d-%m-%Y')

    begin
      @booking = @booking.accommodation_reserve(option)
    rescue QuickTravel::AdapterException => e
      puts e.message.to_s
    end

    @booking.reservations.length.should eq 1

    @booking.reservations.first.passenger_splits.first['consumer_split']['consumer_id'].should == passenger_ids.first
  end

  it 'booking.scheduled_trips_reserve should return updated booking object that includes newly reserved ferry with correct passenger_ids with vehicles' do
    passenger_ids =  @booking.find_or_create_passenger_ids('1' => 1)
    nil_passenger_types = { '1' => nil, '2' => nil, '3' => nil, '4' => nil, '5' => nil }
    vehicle_types = { '1' => 5 }

    # params for adding forward trip to cart
    forward = { passenger_ids: passenger_ids, vehicle_ids: {},
                first_travel_date: (Date.today + 35).strftime('%d-%m-%Y'), resource_id: 1,
                trip_id: 1,
                passenger_types: nil_passenger_types,
                vehicle_types: vehicle_types
    }

    backward = { passenger_ids: passenger_ids, vehicle_ids: {},
                 first_travel_date: (Date.today + 37).strftime('%d-%m-%Y'), resource_id: 1,
                 trip_id: 3,
                 passenger_types: nil_passenger_types,
                 vehicle_types: vehicle_types
    }

    # used Scheduled Trips Reserve API CALL to add trips to cart
    # and then returns updated booking object by using Booking Show API CALL
    begin
      @booking = @booking.scheduled_trips_reserve(2, forward, backward)
    rescue QuickTravel::AdapterException => e
      puts e.message.to_s
    end
  end
end
