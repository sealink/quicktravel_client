require 'spec_helper'
require 'quick_travel/reservation'
require 'quick_travel/booking'

describe QuickTravel::Reservation do
  it 'should create a reservation with a booking' do
    VCR.use_cassette('create_reservation_with_booking') do
      reservation = QuickTravel::Reservation.create(
        resource_id: '4',
        first_travel_date: '2016-03-01',
        passenger_types_numbers: { '1' => '2', '2' => '1' }
      )
      expect(reservation.booking_id).to eq 12
    end
  end

  it 'should fail to create when no availability' do
    VCR.use_cassette 'create_reservation_fail' do
      begin
        QuickTravel::Reservation.create(
          resource_id: '4',
          first_travel_date: '2099-09-10'
        )
      rescue QuickTravel::AdapterError => e
        expect(e.message).to match(/^No services selected for/)
      end
    end
  end

  it 'should fetch the sub reservations' do
    resource_names = nil
    VCR.use_cassette('reservation_with_extra_picks') do
      @booking = QuickTravel::Booking.find(1)
      @reservation = @booking.reservations.first
      sub_reservations = @reservation.sub_reservations
      resource_names = sub_reservations.map(&:resource).map(&:name)
    end
    expect(resource_names).to eq ['Travel Insurance - Declined', 'QBE Travel Insurance - Policy E']
  end
end

describe QuickTravel::Reservation do
  before(:each) do
    @reservation = QuickTravel::Reservation.new(gross_including_packaged_item_in_cents: 265)
  end

  it 'should show me the money' do
    expect(@reservation.gross_including_packaged_item).to be_an_instance_of Money
  end
end
