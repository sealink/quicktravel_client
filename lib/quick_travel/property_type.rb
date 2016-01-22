require 'quick_travel/adapter'

module QuickTravel
  class PropertyType < Adapter
    self.api_base = '/property_types'
    self.lookup = true
  end
end
