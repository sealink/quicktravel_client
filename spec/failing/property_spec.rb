require 'spec_helper'
require 'quick_travel/property'

describe QuickTravel::Property do
  it 'should find a first instance of property with id from QuickTravel' do
    p = Property.first(1, product: { first_travel_date: (Date.today + 1).strftime('%d-%m-%Y') })
    p.should be_a Property
  end

  # wrong params
  it 'should raise Argument Exception in case of invalid argument' do
    begin
      Property.first(nil)
      Property.first('')
      Property.first(true)
      Property.first(1.5)
    rescue => ex
      ex.should be_a ArgumentError
    end
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "property.name for first(1) object should be 'Aurora Ozone Hotel and Apartments'" do
    p = Property.first(1, product: { first_travel_date: (Date.today + 1).strftime('%d-%m-%Y') })
    p.name.should == 'Aurora Ozone Hotel and Apartments'
  end

  # # this test will only work if server is down or request_url in test config file is wrong.
  #   it "Property.first method should raise exception in case of wrong request url or param or in case server is down." do
  #     begin
  #       p = Property.first(1)
  #     rescue => ex
  #       ex.should be_a AdapterException
  #     end
  #   end

  # testing of find method
  it 'Property.find! method should return Property Array object' do
    p = Property.find!(property_type_id: 8, location_id: 5, product: { first_travel_date: (Date.today + 1).strftime('%d-%m-%Y') })
    p.should be_a Array
    p[0].should be_a Property
  end

  # testing of find method
  it 'Property.find!( :property_type_id => 8 , :location_id => 5 ) method should return Property Array object of length 3' do
    p = Property.find!(property_type_id: 8, location_id: 5, product: { first_travel_date: (Date.today + 1).strftime('%d-%m-%Y') })
    p.length.should == 3
  end

  # testing of find method
  # 25-05-2010  API 3.10.1
  # NOT API IS NOT SUPPORTING Property search with property_type_id
  it 'Property.find!( :location_id => 5 ) method should return Property Array object of length 29' do
    p = Property.find!(location_id: 5, product: { first_travel_date: (Date.today + 1).strftime('%d-%m-%Y') })
    p.length.should == 25
  end

  # # testing of find method
  #   it "Property.find! brings the first property = 'Groups: Adelaide Royal Coach' " do
  #       p = Property.find!( :property_type_id => 8 , :location_id => 5 , :product => { :first_travel_date => (Date.today + 1  ).strftime('%d-%m-%Y') } )
  #       p[0].name.should == "Groups: Adelaide Royal Coach"
  #   end
end
