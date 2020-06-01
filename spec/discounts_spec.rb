require 'spec_helper'
require 'quick_travel/reservation'
require 'quick_travel/booking'

describe 'Booking price_changes' do
  let(:booking) do
    VCR.use_cassette('booking_with_price_changes') do
      QuickTravel::Booking.find_by_reference('222223')
    end
  end

  before :each do
    QuickTravel.config.version = 4
  end

  context 'when the booking has a price_change' do
    let(:reservation)                     { booking.reservations.first }
    let(:extra_pick_without_price_change) { reservation.sub_reservations.first }
    let(:extra_pick_with_price_change)    { reservation.sub_reservations.second }

    let(:price_change) do
      VCR.use_cassette('booking_price_changes') do
        booking.price_change
      end
    end

    specify { expect(price_change.target.type).to eq 'Booking' }
    specify { expect(price_change.target.id).to eq booking.id }
    specify { expect(price_change.original_price).to eq 640.00.to_money }
    specify { expect(price_change.changed_price).to eq 380.00.to_money }
    specify { expect(price_change.price_change).to eq(-260.00.to_money) }
    specify do
      expect(price_change.reservation_price_changes.count).to(
        eq booking.reservations.count)
    end

    context 'the price_change applied on the top level reservation' do
      let(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.price_change_on(reservation)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq reservation.id }
      specify { expect(price_change.original_price).to eq 400.00.to_money }
      specify { expect(price_change.changed_price).to eq 200.00.to_money }
      specify { expect(price_change.price_change).to eq(-200.to_money) }
    end

    context 'the total price_change applied on the top level reservation' do
      subject(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.total_price_change_on(reservation)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq reservation.id }
      specify { expect(price_change.original_price).to eq 640.00.to_money }
      specify { expect(price_change.changed_price).to eq 380.00.to_money }
      specify { expect(price_change.price_change).to eq(-260.00.to_money) }
    end

    context 'the price_change applied on the first extra pick' do
      let(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.price_change_on(extra_pick_without_price_change)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq extra_pick_without_price_change.id }
      specify { expect(price_change.original_price).to eq 120.to_money }
      specify { expect(price_change.changed_price).to eq 120.to_money }
      specify { expect(price_change.price_change).to eq 0.to_money }
    end

    context 'the total price_change applied on the first extra pick' do
      let(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.total_price_change_on(extra_pick_without_price_change)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq extra_pick_without_price_change.id }
      specify { expect(price_change.original_price).to eq 120.to_money }
      specify { expect(price_change.changed_price).to eq 120.to_money }
      specify { expect(price_change.price_change).to eq 0.to_money }
    end

    context 'the price_change applied on second extra pick' do
      let(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.price_change_on(extra_pick_with_price_change)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq extra_pick_with_price_change.id }
      specify { expect(price_change.original_price).to eq 120.00.to_money }
      specify { expect(price_change.changed_price).to eq 60.00.to_money }
      specify { expect(price_change.price_change).to eq(-60.00.to_money) }
    end

    context 'the total price_change applied on second extra pick' do
      let(:price_change) do
        VCR.use_cassette('booking_price_changes') do
          booking.total_price_change_on(extra_pick_with_price_change)
        end
      end

      specify { expect(price_change.target.type).to eq 'Reservation' }
      specify { expect(price_change.target.id).to eq extra_pick_with_price_change.id }
      specify { expect(price_change.original_price).to eq 120.00.to_money }
      specify { expect(price_change.changed_price).to eq 60.00.to_money }
      specify { expect(price_change.price_change).to eq(-60.00.to_money) }
    end
  end
end
