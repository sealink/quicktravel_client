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
      subject { all.first }
      its(:class) { should == QuickTravel::ProductType }
      its(:name)  { should == 'Ferry' }
    end
  end
end
