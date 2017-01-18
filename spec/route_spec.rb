require 'spec_helper'
require 'quick_travel/route'

describe QuickTravel::Route do
  let(:ferry_product_type_id) { 1 }
  let(:to_route_id) { 1 }
  let(:from_route_id) { 2 }

  context '#all' do
    subject(:routes) {
      VCR.use_cassette 'route_all' do
        QuickTravel::Route.all(ferry_product_type_id)
      end
    }

    specify { expect(routes.size).to eq 2 }

    context 'first route' do
      subject(:route) { routes.first }

      its(:id) { should eq to_route_id }
      its(:name) { should eq 'To Kangaroo Island' }
      its(:path) { should eq 'Cape Jervis to Penneshaw' }
      its(:position) { should eq 1 }
      its(:product_type_id) { should eq 1 }
      its(:reverse_id) { should eq from_route_id }
      its(:can_choose_stops?) { should eq false }

      context 'route stops' do
        subject(:route_stops) { route.route_stops }

        its(:size) { should eq 2 }

        context 'first stop' do
          subject(:route_stop) { route_stops.first }

          its(:id) { should eq to_route_id }
          its(:name) { should eq 'Cape Jervis' }
          its(:address) { should eq '' }
          its(:code) { should eq 'CPJ' }
          its(:position) { should eq 1 }
          its(:route_id) { should eq 1 }
        end
      end
    end
  end

  context '#find_by_route_id_and_product_type_id' do
    subject(:route) {
      VCR.use_cassette('route_all') do
        QuickTravel::Route.find_by_route_id_and_product_type_id(
          from_route_id,
          ferry_product_type_id
        )
      end
    }

    its(:id) { should eq from_route_id }
    its(:name) { should eq 'From Kangaroo Island' }
    its(:path) { should eq 'Penneshaw to Cape Jervis' }
    its(:position) { should eq 2 }
    its(:product_type_id) { should eq 1 }
    its(:reverse_id) { should eq to_route_id }
  end

  context '#find' do
    let(:routes) {
      VCR.use_cassette('route_all') do
        QuickTravel::Route.all(ferry_product_type_id)
      end
    }
    subject(:route) { QuickTravel::Route.find(routes, from_route_id) }

    its(:name) { should eq 'From Kangaroo Island' }

    context '#get_return_route_stop!' do
      let(:forward_stop) { route.route_stops.first }
      subject(:return_stop) { route.get_return_route_stop!(forward_stop) }

      its(:name) { should eq forward_stop.name }
    end

    context '#get_reverse_route' do
      specify { expect(route.get_reverse_route!.id).to eq to_route_id }
    end

    context '#find_route_stop_by_id' do
      specify { expect(route.find_route_stop_by_id(3).name).to eq 'Penneshaw' }
      specify { expect(route.find_route_stop_by_id(4).name).to eq 'Cape Jervis' }
    end
  end

  context 'reverse route not setup' do
    let(:route) { QuickTravel::Route.new(reverse_id: nil) }

    specify {
      expect { route.get_reverse_route! }.to raise_error(
        QuickTravel::AdapterError,
        'Reverse has not been setup for the selected route.'
      )
    }
  end

  context 'reverse route cant be found' do
    let(:route) {
      QuickTravel::Route.new(
        reverse_id: 42,
        product_type_id: ferry_product_type_id
      )
    }

    specify {
      expect { route.get_reverse_route! }.to raise_error(
        QuickTravel::AdapterError,
        'Reverse does not exist for the selected route.'
      )
    }
  end
end
