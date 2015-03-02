require 'quick_travel/adapter'

module QuickTravel
  class RoomFacility < Adapter
    attr_accessor :id, :accommodation_id, :category_id, :created_at, :name, :position, :room_facility_id, :updated_at
  end
end
