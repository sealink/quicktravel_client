require 'spec_helper'

require 'quick_travel/price_quote'

describe QuickTravel::PriceQuote do
  context 'when calculating' do
    let(:reservation_params) {
      { resource_id: 805, quantity: 3, first_travel_date: '2016-04-15'}
    }
    let(:params) {
      { reservations: [reservation_params] }
    }
    let(:price_quote) { QuickTravel::PriceQuote.calculate(params) }

    before do
      VCR.use_cassette('price_quote') do
        price_quote
      end
    end

    specify { expect(price_quote.quoted_booking_gross.cents).to eq 7680 }
    specify { expect(price_quote.applied_rules).to eq ['Special Offer'] }
  end
end