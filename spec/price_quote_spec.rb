require 'spec_helper'

require 'quick_travel/price_quote'

describe QuickTravel::PriceQuote do
  context 'when calculating' do
    let(:reservation_params) {
      { resource_id: 7, quantity: quantity, first_travel_date: '2016-04-15' }
    }
    let(:params) {
      { reservations: [reservation_params] }
    }
    let(:price_quote) {
      VCR.use_cassette('price_quote', record: :new_episodes) {
        QuickTravel::PriceQuote.calculate(params)
      }
    }

    context 'when no rules are applied' do
      let(:quantity) { 2 }

      specify { expect(price_quote.quoted_booking_gross.cents).to eq 6400 }
      specify { expect(price_quote.applied_rules).to be_empty }
    end

    context 'when rules are applied' do
      let(:quantity) { 3 }

      specify { expect(price_quote.quoted_booking_gross.cents).to eq 4800 }
      specify { expect(price_quote.applied_rules).to eq ['Special Offer'] }
    end
  end
end