require 'spec_helper'
require 'quick_travel/resource_category'

describe QuickTravel::ResourceCategory do
  context '#all' do
    subject(:all) do
      VCR.use_cassette('resource_category_all') {
        QuickTravel::ResourceCategory.all
      }
    end

    its(:class) { should == Array }
    its(:length) { should == 4 }

    context 'first element' do
      subject { all.first }
      its(:class) { should == QuickTravel::ResourceCategory }
      its(:name)  { should == 'Common' }
    end

    context 'when filtering a product type' do
      subject(:all_for_product_type) do
        VCR.use_cassette('resource_category_all_for_product_type_8') {
          QuickTravel::ResourceCategory.all(product_type_ids: [8])
        }
      end

      its(:class) { should == Array }
      its(:length) { should == 2 }

      context 'first element' do
        subject { all_for_product_type.first }
        its(:class) { should == QuickTravel::ResourceCategory }
        its(:name)  { should == 'General' }
      end
    end
  end
end
