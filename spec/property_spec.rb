require 'spec_helper'
require 'quick_travel/address'
require 'quick_travel/accommodation'
require 'quick_travel/country'
require 'quick_travel/property'

describe QuickTravel::Property do
  let(:opts) { { first_travel_date: Date.new(2016, 1, 1) } }
  subject(:property) {
    VCR.use_cassette 'property' do
      QuickTravel::Property.load_with_pricing(1, product: opts)
    end
  }

  before do
    VCR.use_cassette 'countries' do
      QuickTravel::Country.all # preload countries for address
    end
  end

  its(:id) { should eq 1 }
  its(:name) { should eq 'Hilton Hotel' }

  context 'its address' do
    subject(:address) { property.address }
    its(:id) { should eq 1 }
    its(:address_line1) { should eq 'Level 2' }
    its(:address_line2) { should eq '1 Victoria Square' }
    its(:city) { should eq 'Adelaide' }
    its(:state) { should eq 'SA' }
    its(:post_code) { should eq '5000' }
    its(:country_id) { should eq 14 }
    its(:country_name) { should eq 'Australia' }
  end

  context 'its property facilities' do
    subject(:property_facilities) { property.property_facilities }

    its(:size) { should eq 2 }

    specify { expect(subject.map(&:name)).to eq ['Pool', 'Spa'] }

    context 'first property facility' do
      subject { property_facilities.first }

      its(:id) { should eq 1 }
      its(:name) { should eq 'Pool' }
      its(:category_id) { should eq 1 }
      its(:position) { should eq 1 }
      its(:created_at) { should be_a(Date) }
      its(:updated_at) { should be_a(Date) }
    end
  end

  context 'its accommodations' do
    subject(:accommodations) { property.accommodations }

    its(:size) { should eq 1 }
  end

  context 'first accommodation' do
    subject(:accommodation) { property.accommodations.first }

    context 'its room facilities' do
      subject(:room_facilities) { accommodation.room_facilities }

      its(:size) { should eq 2 }

      specify { expect(subject.map(&:name)).to eq ['Shower', 'Hairdryer'] }

      context 'first room facility' do
        subject(:room_facility) { room_facilities.first }

        its(:id) { should eq 1 }
        its(:name) { should eq 'Shower' }
        its(:category_id) { should eq 2 }
        its(:position) { should eq 1 }
        its(:created_at) { should be_a(Date) }
        its(:updated_at) { should be_a(Date) }
      end
    end
  end
end
