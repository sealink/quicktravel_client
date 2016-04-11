require 'spec_helper'
require 'quick_travel/product_type'

describe QuickTravel::ProductType do
  context '#all' do
    subject(:all) do
      VCR.use_cassette('product_type_all') { QuickTravel::ProductType.all }
    end

    its(:class) { should == Array }
    its(:length) { should == 8 }

    context 'first element' do
      subject(:ferry) { all.first }
      its(:class) { should == QuickTravel::ProductType }
      its(:name)  { should == 'Ferry' }

      context '#routes' do
        subject {
          VCR.use_cassette 'product_type_routes' do
            ferry.routes
          end
        }
        its(:size) { should eq 2 }
        its('first.name') { should eq 'To Kangaroo Island' }
      end
    end
  end
end
