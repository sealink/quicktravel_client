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
end
