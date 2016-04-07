require 'spec_helper'
require 'quick_travel/resource'

describe QuickTravel::Resource do
  subject(:resource) {
    VCR.use_cassette('resource_show') do
      QuickTravel::Resource.find(6)
    end
  }

  its(:name) { should eq 'Executive Room' }

  it 'should find fare bases of a resource' do
    VCR.use_cassette('resource_fare_bases') do
      picks = resource.sub_resources
      expect(picks.size).to eq 2
      expect(picks.map(&:name)).to eq ['QBE Travel Insurance - Policy E', 'Travel Insurance - Declined']
    end
  end

  context '#product_type' do
    subject(:property_type) {
      VCR.use_cassette 'resource_product_type' do
        resource.product_type
      end
    }

    its(:name) { should eq 'Accommodation' }
  end

  context '#all_with_price' do
    let(:ticket_product_type_id) { 5 }
    subject(:response) {
      VCR.use_cassette 'resource_with_price' do
        QuickTravel::Resource.all_with_price(product_type_ids: ticket_product_type_id)
      end
    }

    its(:count) { should eq 3 }

    context 'first resource' do
      subject(:resource) { response.first }
      its(:todays_price) { should eq 32.to_money }
    end
  end
end
