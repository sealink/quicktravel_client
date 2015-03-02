require 'spec_helper'
require 'quick_travel/country'

describe QuickTravel::Country do
  before do
    VCR.use_cassette('country_all') do
      @countries = QuickTravel::Country.all
    end
  end

  it 'should fetch all countries' do
    expect(@countries).to_not be_empty
    au = @countries.detect { |c| c.iso_3166_code == 'AU' }
    expect(au.name).to eq 'Australia'
    au.id
    expect(QuickTravel::Country.find(au.id).name).to eq 'Australia'
  end
end
