require 'spec_helper'
require 'quick_travel/region'

describe QuickTravel::Region do
  describe '#first' do
    subject { QuickTravel::Region.all.first }

    it 'should find a first instance of region from QuickTravel' do
      VCR.use_cassette('region_show') do
        expect(subject).to be_an_instance_of QuickTravel::Region
        expect(subject.id).to be_a_kind_of Integer
        expect(subject.name).to be_an_instance_of String
        expect(subject.location_ids).to be_an_instance_of Array
        expect(subject.location_ids[0]).to be_a_kind_of Integer
      end
    end
  end

  describe '#all' do
    subject { QuickTravel::Region.all }

    it 'Region.all method should return Array of Regions' do
      VCR.use_cassette('region_index') do
        expect(subject).to be_an_instance_of Array
        expect(subject[0]).to be_an_instance_of QuickTravel::Region
      end
    end
  end
end
