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
end
