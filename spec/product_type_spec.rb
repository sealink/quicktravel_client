require 'spec_helper'
require 'quick_travel/product_type'
require 'quick_travel/resource_category'

describe QuickTravel::ProductType do
  context '#all' do
    subject(:all) do
      VCR.use_cassette('product_type_all') { QuickTravel::ProductType.all }
    end

    its(:class) { should == Array }
    its(:length) { should == 9 }

    context 'first element' do
      subject(:ferry) { all.first }
      its(:class) { should == QuickTravel::ProductType }
      its(:name)  { should == 'Ferry' }

      context '#resource_category_ids' do
        subject {
          VCR.use_cassette 'product_type_resource_categories' do
            ferry.resource_categories
          end
        }
        its(:size) { should eq 0 }
      end

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

    context 'tickets product type' do
      subject(:tickets) {
        all.detect { |product_type| product_type.name == 'Ticket' }
      }

      context '#resource_category_ids' do
        subject {
          VCR.use_cassette 'product_type_resource_categories_tickets' do
            tickets.resource_categories
          end
        }
        its(:size) { should eq 2 }
        its('first.name') { should eq 'Common' }
      end
    end
  end
end
