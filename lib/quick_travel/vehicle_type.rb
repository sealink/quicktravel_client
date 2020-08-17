require 'quick_travel/adapter'

module QuickTravel
  class VehicleType < Adapter
    self.api_base = '/api/vehicle_types'
    self.lookup = true
  end
end
