require 'spec_helper'
require 'quick_travel/reservation'
require 'quick_travel/booking'

describe 'Booking discounts' do
  let(:booking) do
    VCR.use_cassette('booking_with_discounts') do
      QuickTravel::Booking.find_by_reference('222223')
    end
  end

  before :each do
    QuickTravel.config.version = 4
  end

  context 'when the booking has a discount' do
    let(:reservation)                 { booking.reservations.first }
    let(:extra_pick_without_discount) { reservation.sub_reservations.first }
    let(:extra_pick_with_discount)    { reservation.sub_reservations.second }

    let(:discount) do
      VCR.use_cassette('booking_discounts') do
        booking.discount
      end
    end

    specify { expect(discount.target.type).to eq 'Booking' }
    specify { expect(discount.target.id).to eq booking.id }
    specify { expect(discount.original_price).to eq 640.00 }
    specify { expect(discount.discounted_price).to eq 380.00 }
    specify { expect(discount.discount).to eq(-260.00) }
    specify do
      expect(discount.reservation_discounts.count).to(
        eq booking.reservations.count)
    end

    context 'the discount applied on the top level reservation' do
      let(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.discount_on(reservation)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq reservation.id }
      specify { expect(discount.original_price).to eq 400.00 }
      specify { expect(discount.discounted_price).to eq 200.00 }
      specify { expect(discount.discount).to eq(-200) }
    end

    context 'the total discount applied on the top level reservation' do
      subject(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.total_discount_on(reservation)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq reservation.id }
      specify { expect(discount.original_price).to eq 640.00 }
      specify { expect(discount.discounted_price).to eq 380.00 }
      specify { expect(discount.discount).to eq(-260.00) }
    end

    context 'the discount applied on the first extra pick' do
      let(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.discount_on(extra_pick_without_discount)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq extra_pick_without_discount.id }
      specify { expect(discount.original_price).to eq 120 }
      specify { expect(discount.discounted_price).to eq 120 }
      specify { expect(discount.discount).to eq 0 }
    end

    context 'the total discount applied on the first extra pick' do
      let(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.total_discount_on(extra_pick_without_discount)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq extra_pick_without_discount.id }
      specify { expect(discount.original_price).to eq 120 }
      specify { expect(discount.discounted_price).to eq 120 }
      specify { expect(discount.discount).to eq 0 }
    end

    context 'the discount applied on second extra pick' do
      let(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.discount_on(extra_pick_with_discount)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq extra_pick_with_discount.id }
      specify { expect(discount.original_price).to eq 120.00 }
      specify { expect(discount.discounted_price).to eq 60.00 }
      specify { expect(discount.discount).to eq(-60.00) }
    end

    context 'the total discount applied on second extra pick' do
      let(:discount) do
        VCR.use_cassette('booking_discounts') do
          booking.total_discount_on(extra_pick_with_discount)
        end
      end

      specify { expect(discount.target.type).to eq 'Reservation' }
      specify { expect(discount.target.id).to eq extra_pick_with_discount.id }
      specify { expect(discount.original_price).to eq 120.00 }
      specify { expect(discount.discounted_price).to eq 60.00 }
      specify { expect(discount.discount).to eq(-60.00) }
    end
  end
end
