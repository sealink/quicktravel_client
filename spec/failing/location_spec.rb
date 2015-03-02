require 'spec_helper'
require 'quick_travel/location'

describe QuickTravel::Location do
  it 'should find a first instance of location from QuickTravel' do
    p = Location.first
    p.should be_a Location
  end

  it 'location.id should be number' do
    p = Location.first
    p.id.should be_a Fixnum
  end

  it 'location.name should be string' do
    p = Location.first
    p.name.should be_a String
  end

  it 'location.region_ids should be number array' do
    p = Location.first
    p.region_ids.should be_a Array
    p.region_ids[0].should be_a Fixnum
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "location.name for first object should be 'Adelaide CBD'" do
    p = Location.first
    p.name.should == 'Adelaide CBD'
  end

  it 'Location.all method should return Array type object' do
    p = Location.all
    p.should be_a Array
  end

  it 'Location.all method should bring Array of Location records' do
    p = Location.all
    p[0].should be_a Location
  end

  # this test is based on current number of records in Test environment of Seaklink API_demo
  # updated for API 3.8.1
  it 'Location.all method should bring 75 records' do
    p = Location.all
    p.length.should == 76
  end

  # this test will only work if server is down or request_url in test config file is wrong.
  it 'Location.first method should return exception in case of wrong request url or param or in case server is down.' do
    begin
      Location.first
    rescue => ex
      ex.should be_a AdapterException
    end
  end
end
