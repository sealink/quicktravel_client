require 'spec_helper'
require 'quick_travel/package'

describe QuickTravel::Package do
  subject(:package) {
    VCR.use_cassette('package_show') do
      QuickTravel::Package.find(464)
    end
  }

  its(:name) { should eq 'Swan Valley Gourmet Wine Cruise (SVGWC-0945)' }
  its(:type) { should eq 'Package' }


  context '#product_type' do
    subject(:property_type) {
      VCR.use_cassette 'package_show_product_type' do
        package.product_type
      end
    }

    its(:name) { should eq 'Rottnest Packages' }
  end
end
