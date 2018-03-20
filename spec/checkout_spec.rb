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

  context 'Modern Opal Pay' do
    context 'failed payment' do
      let!(:booking) {
        VCR.use_cassette('opal_modern_pay_failed_booking') do
          QuickTravel.config.version = 4
          QuickTravel::Booking.create
        end
      }
      let(:create_payment_request) {
        {
          booking_id: booking.id,
          payment: {
            payment_type_id: 10,
            amount_in_cents: 10,
            uid: 'modern-opal-failed-uid',
            comment: 'Test Opal Payment'
          }
        }
      }

      let!(:create_payment_response) {
        VCR.use_cassette('opal_modern_pay_failed_create') do
          QuickTravel::Checkout.create(create_payment_request)
        end
      }

      let(:udpate_payment_request) {
        {
          gateway_response: {
            raw_response: '{
              "CardNumber": 3085227007682330,
              "CardBalance": 6546,
              "CardSequenceNumber": 55,
              "CILAmount": 0,
              "AuthorizedAmount": 890,
              "SalesReferenceNumber": 53183943,
              "TransactionDTM": "2018-01-04T09:00:43.106",
              "VoidTransactionReferenceNumber": 1271099697,
              "CardBlockState": false,
              "AutoloadAmount": 0
              }',
            meta_data: {
              applicationInstanceId: 101166,
              operatorId: 'an_operator'
            },
            success: false
          }
        }
      }

      let(:update_payment_response) {
        VCR.use_cassette('opal_modern_pay_failed_update') do
          QuickTravel::Checkout.update(create_payment_response.id, udpate_payment_request)
        end
      }

      let(:expected_create_attributes) { { completable: false } }
      let(:expected_update_attributes) { { successful: false } }
      it 'should update correctly' do
        expect(create_payment_response).to have_attributes(expected_create_attributes)
        expect(update_payment_response).to have_attributes(expected_update_attributes)
      end
    end

    context 'successful payment' do
      let!(:booking) {
        VCR.use_cassette('opal_modern_pay_successful_booking') do
          QuickTravel.config.version = 4
          QuickTravel::Booking.create
        end
      }
      let(:payment_create_request) {
        {
          booking_id: booking.id,
          payment: {
            payment_type_id: 10,
            amount_in_cents: 10,
            uid: 'modern-opal-uid',
            comment: 'Test Opal Payment'
          }
        }
      }

      let!(:create_payment_response) {
        VCR.use_cassette('opal_modern_pay_successful_response') do
          QuickTravel::Checkout.create(payment_create_request)
        end
      }

      let(:update_payment_request) {
        {
          gateway_response: {
            raw_response: '{
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
            meta_data: {
              applicationInstanceId: 101166,
              operatorId: 'an_operator'
            },
            success: true
          }
        }
      }

      let(:update_payment_response) {
        VCR.use_cassette('opal_modern_pay_successful_update_response') do
          QuickTravel::Checkout.update(create_payment_response.id, update_payment_request)
        end
      }

      let(:expected_create_attributes) { { completable: false } }
      let(:expected_update_attributes) { { successful: true } }
      it 'should update correctly' do
        expect(create_payment_response).to have_attributes(expected_create_attributes)
        expect(update_payment_response).to have_attributes(expected_update_attributes)
      end
    end
  end

  context 'Opal Pay' do
    let(:booking) {
      VCR.use_cassette('opal_pay_booking') do
        QuickTravel.config.version = 4
        QuickTravel::Booking.create
      end
    }

    let(:payment_create_request) {
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
          meta_data: {
            applicationInstanceId: 101166,
            operatorId: 'an_operator'
          },
          payment_type_id: 10,
          amount_in_cents: 10,
          uid: 'opal-uid',
          comment: 'Test Opal Payment'
        }
      }
    }

    subject(:response) {
      VCR.use_cassette('opal_pay') do
        QuickTravel::Checkout.create(payment_create_request)
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
