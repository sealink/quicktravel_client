require 'spec_helper'
require 'quick_travel/setting'

describe QuickTravel::Checkout do
  subject {
    VCR.use_cassette 'settings_basic' do
      QuickTravel::Setting.basic
    end
  }

  specify do
    expect(subject.vehicle_optional_fields).to eq %w(weight registration)
    expect(subject.default_passenger_type_id).to eq 1
    expect(subject.time_zone).to eq 'Australia/Adelaide'
    expect(subject.ob_num_pax_requiring_details).to eq 'none'
    expect(subject.person_titles).to eq %w(Mr Mrs Ms Miss)
  end
end
