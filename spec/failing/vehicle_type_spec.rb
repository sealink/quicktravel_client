require 'spec_helper'
require 'quick_travel/vehicle_type'

describe QuickTravel::VehicleType do
  it 'should find a first instance of vehicle_type from QuickTravel' do
    p = VehicleType.first
    p.should be_a VehicleType
  end

  it ' should have same values of attributes as JSON RESPONSE HASH HAS' do
    json_hash = VehicleType.get('/vehicle_types.json')

    p = VehicleType.first

    json_hash[0]['vehicle_type'].each do |attr, val|
      p.instance_variable_get(('@' + attr.to_s) .to_sym).should == val
    end
  end

  # this test is based on current records in Test environment of Seaklink API_demo
  it "vehicle_type.name for first object should be 'Standard Vehicle'" do
    p = VehicleType.first
    p.name.should == 'Standard Vehicle'
  end

  it 'VehicleType.all method should return VehicleType Array object' do
    p = VehicleType.all
    p.should be_a Array
    p[0].should be_a VehicleType
  end

  # this test is based on current number of records in Test environment of Seaklink API_demo
  it 'VehicleType.all method should bring 11 records' do
    p = VehicleType.all
    p.length.should == 12
  end

  # this test will only work if server is down or request_url in test config file is wrong.
  it 'VehicleType.first method should return exception in case of wrong request url or param or in case server is down.' do
    begin
      VehicleType.first
    rescue => ex
      ex.should be_a AdapterException
    end
  end
end
