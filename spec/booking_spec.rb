require 'spec_helper'
require 'quick_travel/booking'
require 'quick_travel/document'

describe QuickTravel::Booking do
  before(:each) do
    @booking = QuickTravel::Booking.new(gross_in_cents: 500)
  end

  it 'should show me the money' do
    expect(@booking.gross).to be_an_instance_of Money
    expect(@booking.gross).to eq 5.to_money
    expect(@booking.gross_in_cents).to eq 500
  end
end

describe QuickTravel::Booking, '#on_account_payment_type' do
  subject(:booking) { QuickTravel::Booking.new }
  before { allow(booking).to receive(:payment_types) { payment_types } }
  let(:reference)  { double(code: 'on_account_with_reference') }
  let(:on_account) { double(code: 'on_account_without_reference') }
  let(:cash)       { double(code: 'Cash') }

  context 'when no on account types are applicable' do
    let(:payment_types) { [cash] }
    its(:on_account_payment_type) { should be nil }
  end

  context 'when only reference required' do
    let(:payment_types) { [cash, reference] }
    its(:on_account_payment_type) { should eq reference }
  end

  context 'when both on account and reference required' do
    let(:payment_types) { [cash, reference, on_account] }
    its(:on_account_payment_type) { should be on_account }
  end
end

describe QuickTravel::Booking do
  before(:each) do
    VCR.use_cassette('booking_create') do
      QuickTravel.config.version = 4
      @booking = QuickTravel::Booking.create
    end
  end

  it 'should find a first instance of booking with given booking.id from QuickTravel' do
    VCR.use_cassette('booking_show') do
      b = QuickTravel::Booking.find(@booking.id)
      expect(b).to be_an_instance_of QuickTravel::Booking
      expect(b.id).to eq @booking.id
    end
  end

  it 'should be able to return its assigned reservations' do
    VCR.use_cassette('booking_show') do
      b = QuickTravel::Booking.find(@booking.id)
      expect(b.reservations).to be_an_instance_of Array
      expect(b.reservations.size).to eq 0
    end
  end

  it 'should be able to update the booking' do
    VCR.use_cassette('booking_update') do
      response = @booking.update(customer_contact_name: 'John')
      expect(response.class).to eq QuickTravel::Booking
    end
  end

  it 'should not have booking documents' do
    VCR.use_cassette('booking_documents') do
      expect(@booking.documents.size).to eq 0
    end
  end
end

describe QuickTravel::Booking do
  let(:booking) { QuickTravel::Booking.find(1) }
  it 'should have booking documents' do
    VCR.use_cassette('booking_with_documents') do
      expect(booking.documents.size).to eq 1
    end
  end
end
