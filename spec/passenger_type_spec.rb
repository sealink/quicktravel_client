require 'spec_helper'
require 'quick_travel/passenger_type'

describe QuickTravel::PassengerType do
  context '#all' do
    subject(:all) do
      VCR.use_cassette('passenger_all') { QuickTravel::PassengerType.all }
    end

    its(:class) { should == Array }
    its(:length) { should == 3 }

    context 'first element' do
      subject { all.first }
      its(:class) { should == QuickTravel::PassengerType }
      its(:name)  { should == 'Adult' }
    end
  end

  context '#passenger_count_to_s' do
    subject(:count) { QuickTravel::PassengerType.passenger_counts(hash) }
    context 'when passengers types have zero counts' do
      let(:hash) { { 1 => 2, 2 => 1, 3 => 0 } }
      it { should eq ['2 Adults', '1 Child'] }
    end

    context 'when passenger types are not specified' do
      let(:hash) { { 1 => 2 } }
      it { should eq ['2 Adults'] }
    end
  end

  context 'caching of collection' do
    subject(:all) do
      VCR.use_cassette('passenger_all') { QuickTravel::PassengerType.all }
    end

    let(:api) { double }

    before do
      stub_const('QuickTravel::Api', api)
      allow(api).to receive(:call_and_validate) { double(parsed_response: [{id: 1}, {id: 2}], headers: {}) }
    end
    
    context 'when called the first time' do
      before do
        QuickTravel::Cache.cache_store.clear
        all
      end
      
      specify { expect(api).to have_received(:call_and_validate).once }
      
      context 'when called again' do
        before do
          QuickTravel::PassengerType.all
        end
        
        specify { expect(api).to have_received(:call_and_validate).once } # not called again
      end
    end
  end
end
