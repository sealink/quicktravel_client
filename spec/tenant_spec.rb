require 'spec_helper'
require 'quick_travel/adapter'
require 'quick_travel/product_type'

describe QuickTravel::Adapter do
  let(:tenant1) { 'http://sealink.dev:8080' }
  let(:tenant2) { 'http://sealinkqld.dev:8080' }

  let(:qt_keys) { ENV['QT_KEYS'].split(',') }

  it 'should switch bases' do
    VCR.use_cassette 'tenant_switcher' do
      QuickTravel::Adapter.base_uri tenant1
      QuickTravel.config.access_key = qt_keys[1]

      expect(QuickTravel::Adapter.base_uri).to eq tenant1
      QuickTravel::ProductType.find_all!("/api/product_types.json")
      expect(QuickTravel::ProductType.base_uri).to eq tenant1

      QuickTravel::Adapter.base_uri tenant2
      QuickTravel.config.access_key = qt_keys[2]

      expect(QuickTravel::Adapter.base_uri).to eq tenant2
      QuickTravel::ProductType.find_all!("/api/product_types.json")
      expect(QuickTravel::ProductType.base_uri).to eq tenant2
    end
  end
end
