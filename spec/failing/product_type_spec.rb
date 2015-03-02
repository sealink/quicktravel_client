require 'spec_helper'
require 'quick_travel/product_type'

describe QuickTravel::ProductType do
  it 'should find a first instance of product_type from QuickTravel' do
    p = ProductType.first
    p.should be_a ProductType
  end

  it 'product_type should have same values of attributes as JSON RESPONSE HASH HAS' do
    json_hash = ProductType.get('/product_types.json')

    p = ProductType.first

    json_hash[0]['product_type'].each do |attr, val|
      p.instance_variable_get(('@' + attr.to_s) .to_sym).should == val
    end
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "product_type.name for first object should be 'Accommodation'" do
    p = ProductType.first
    p.name.should == 'Accommodation'
  end

  it 'ProductType.all method should return ProductType Array object' do
    p = ProductType.all
    p.should be_a Array
    p[0].should be_a ProductType
  end

  # this test is based on current number of records in Test environment of Seaklink API_demo
  it 'ProductType.all method should bring 29 records' do
    p = ProductType.all
    p.length.should == 25
  end

  # exception testing

  # this test will only work if server is down or request_url in test config file is wrong.
  it 'ProductType.first method should return exception in case of wrong request url or param or in case server is down.' do
    begin
      ProductType.first
    rescue => ex
      ex.should be_a AdapterException
    end
  end

  # product_type_object.route

  # this test is based on current records in Test environment of Seaklink API_demo
  it 'ProductType.all[4].route should be Route object' do
    p = ProductType.all[4]
    p.route.should be_a QTRoute
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "ProductType.all[4].route.path should be 'Cape Jervis to Penneshaw' " do
    p = ProductType.all[4]
    p.route.path.should == 'Adelaide Airport to Kingscote Airport'
  end

  # product_type_object.routes

  # this test is based on current number of records in Test environment of Seaklink API_demo
  it 'ProductType.all[4].routes method should bring 2 records of Route' do
    p = ProductType.all[4].routes
    p.length.should eq 4
    p.should be_a Array
    p[0].should be_a QTRoute
  end

  it 'ProductType.all[4].route should have same values of attributes as JSON RESPONSE HASH HAS' do
    p = ProductType.all[4]
    r = p.route
    json_hash = QTRoute.get("/product_types/#{p.id}/routes.json")

    json_hash[0].each do |attr, val|
      r.instance_variable_get(('@' + attr.to_s) .to_sym).should == val
    end
  end
end
