require 'spec_helper'
require 'quick_travel/property_type'

describe QuickTravel::PropertyType do
  it 'should find a first instance of property_type from QuickTravel' do
    p = PropertyType.first
    p.should be_a PropertyType
  end

  it 'property_type.id should be number' do
    p = PropertyType.first
    p.id.should be_a Fixnum
  end

  it 'property_type.name should be string' do
    p = PropertyType.first
    p.name.should be_a String
  end

  it 'property_type.position should be number' do
    p = PropertyType.first
    p.position.should be_a Fixnum
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "property_type.name for first object should be 'Hotel or Motel'" do
    p = PropertyType.first
    p.name.should == 'Hotel or Motel'
  end

  it 'PropertyType.all method should return Array type object' do
    p = PropertyType.all
    p.should be_a Array
  end

  it 'PropertyType.all method should bring Array of PropertyType records' do
    p = PropertyType.all
    p[0].should be_a PropertyType
  end

  # this test is based on current number of records in Test environment of Seaklink API_demo
  it 'PropertyType.all method should bring 7 records' do
    p = PropertyType.all
    p.length.should == 7
  end

  # this test will only work if server is down or request_url in test config file is wrong.
  it 'PropertyType.first method should return exception in case of wrong request url or param or in case server is down.' do
    begin
      PropertyType.first
    rescue => ex
      ex.should be_a AdapterException
    end
  end
end
