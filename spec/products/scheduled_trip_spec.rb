require 'spec_helper'
require 'quick_travel/products/scheduled_trip'

describe QuickTravel::Products::ScheduledTrip do
  let(:params) {
    {
      product_type_id: 1,
      route_id: 1,
      forward: {
        first_travel_date: date,
        passenger_types: { '1' => '2' } # 2 adults
      }
    }
  }
  let(:date) { '2016-03-01' }
  subject(:products) {
    VCR.use_cassette 'basic_product_scheduled_trips' do
      QuickTravel::Products::ScheduledTrip.find(params)
    end
  }

  its(:size) { should == 4 }

  context 'first product' do
    subject(:product) { products.first }

    it { should be_normally_bookable }
    its(:price) { should eq 40.to_money }
    its(:from_route_stop) { should be nil }
    its(:to_route_stop) { should be nil }
  end

  context 'when date has no services' do
    subject(:unbookable_products) {
      VCR.use_cassette 'basic_product_scheduled_trips_unbookable' do
        QuickTravel::Products::ScheduledTrip.find(params)
      end
    }
    let(:date) { '2016-03-03' }

    it { should be_empty }
  end

  context 'multi sector' do
    let(:params) {
      {
        product_type_id: 6,
        route_id: 3,
        forward: {
          first_travel_date: date,
          from_route_stop_id: 5,
          to_route_stop_id: 14,
          passenger_types: { '1' => '2' } # 2 adults
        }
      }
    }
    let(:date) { '2016-03-01' }
    subject(:products) {
      VCR.use_cassette 'basic_product_scheduled_trips_multi_sector' do
        QuickTravel::Products::ScheduledTrip.find(params)
      end
    }

    its(:size) { should == 2 }

    context 'first product' do
      subject(:product) { products.first }

      it { should be_normally_bookable }
      its(:price) { should eq 30.to_money }
      its('from_route_stop.name') { should eq 'Adelaide Central Bus Station' }
      its('to_route_stop.name') { should eq 'Cape Jervis Ferry Terminal' }
      its(:from_route_stop_id) { should eq 5 }
      its(:to_route_stop_id) { should eq 14 }
    end
  end
end
