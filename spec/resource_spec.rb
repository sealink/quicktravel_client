require 'spec_helper'
require 'quick_travel/resource'

describe QuickTravel::Resource do
  before do
    VCR.use_cassette('resource_show') do
      @resource = QuickTravel::Resource.find(6)
    end
  end

  it 'should fetch a resource' do
    expect(@resource.name).to eq 'Executive Room'
  end

  it 'should find fare bases of a resource' do
    VCR.use_cassette('resource_fare_bases') do
      picks = @resource.sub_resources
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
end
