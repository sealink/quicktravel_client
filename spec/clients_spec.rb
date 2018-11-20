# frozen_string_literal: true

require 'spec_helper'
require 'quick_travel/client'

describe QuickTravel::Client do
  context '#find' do
    let(:templates) do
      VCR.use_cassette('client_templates') do
        QuickTravel::Client.find(2).templates
      end
    end
    it 'should find the templates correctly' do
      expect(templates['vehicle_templates']).to eq([
        {
          'id' => 1,
          'length' => 5.0,
          'height' => 1.5,
          'width' => 1.8,
          'weight' => 1000.0,
          'details' => 'Holden Commodore',
          'registration' => 'ABC123',
          'cargo' => 'None',
          'vehicle_type_id' => 1,
          'party_id' => 9
        }
      ])
      expect(templates['passenger_templates']).to eq([
        {
          'id' => 1,
          'age' => 30,
          'title' => 'Mr',
          'first_name' => 'Homer',
          'last_name' => 'Simpson',
          'gender' => 'Male',
          'passenger_type_id' => 1,
          'party_id' => 9
        }
      ])
    end
  end
end
