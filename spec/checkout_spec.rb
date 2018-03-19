require 'spec_helper'
require 'quick_travel/checkout'

describe QuickTravel::Checkout do
  subject(:token) {
    VCR.use_cassette 'checkout_client_token' do
      QuickTravel::Checkout.client_token(gateway: 'braintree')
    end
  }

  specify do
    expect(token.keys).to eq [:client_token]
    expect(token[:client_token]).to match /^[0-9A-Za-z\=]+$/
  end

  context 'Opal Pay' do
    let(:booking) {
      VCR.use_cassette('opal_pay_booking') do
        QuickTravel.config.version = 4
        QuickTravel::Booking.create
      end
    }

    let(:data) {
      {
        booking_id: booking.id,
        payment: {
          gateway_response: '{
            "CardNumber": 3085227007682330,
            "CardBalance": 6546,
            "CardSequenceNumber": 55,
            "CILAmount": 0,
            "AuthorizedAmount": 890,
            "SalesReferenceNumber": 53183943,
            "TransactionDTM": "2018-01-04T09:00:43.106",
            "TransactionReferenceNumber": 1271099697,
            "CardBlockState": false,
            "AutoloadAmount": 0
            }',
          meta_data: '{"applicationInstanceId":"101166","operatorId":"an_operator"}',
          payment_type_id: 10,
          amount_in_cents: 10,
          uid: 'random-payment-id',
          comment: 'Test Opal Payment'
        }
      }
    }

    subject(:response) {
      VCR.use_cassette('opal_pay') do
        QuickTravel::Checkout.create(data)
      end
    }

    let(:expected_attributes) {
      {
        completable: true,
        completed: true,
        progress: 'completed',
        successful: true
      }
    }

    it { is_expected.to have_attributes(expected_attributes) }
  end
end
