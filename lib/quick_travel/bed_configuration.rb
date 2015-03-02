require 'quick_travel/adapter'

module QuickTravel
  class BedConfiguration < Adapter
    attr_accessor :created_at, :creator_id, :id, :name, :overriding_fare_basis_pointer_id, :resource_id, :updated_at, :updator_id
  end
end
