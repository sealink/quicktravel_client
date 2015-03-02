require 'spec_helper'
require 'quick_travel/product'

describe QuickTravel::Product do
  it 'Product.find(:generics) method should return Product Array object' do
    param = { product_type_id: Product.activities_product_id,  product: { first_travel_date: '26-05-2010', passenger_types: { '1' => nil, '2' => nil, '3' => nil, '4' => nil, '5' => nil }, duration: nil,  quantity: nil }  }

    p = Product.find(:generics, param)
    p.should be_a Array
    p[0].should be_a Product
  end

  it 'Product.find(:trips) method should return Product Array object' do
    param = { product_type_id: Product.ferries_product_id, route_id: 2,  forward: { first_travel_date: '26-05-2010', passenger_types: { '1' => 1, '2' => nil, '3' => nil, '4' => nil, '5' => nil }  }  }

    p = Product.find(:trips, param)
    p.should be_a Array
    p[0].should be_a Product
  end

  # testing of activities method
  it 'Product.activities method should return Product Array object' do
    p = Product.activities('26-05-2010')
    p.should be_a Array
    p[0].should be_a Product
  end
end
