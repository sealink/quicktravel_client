require 'quick_travel/adapter'

module QuickTravel
  class PropertyFacility < Adapter
    attr_accessor :id, :property_id, :category_id, :created_at, :name, :position, :property_facility_id, :updated_at
  end
end
