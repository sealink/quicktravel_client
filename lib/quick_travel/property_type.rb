require 'quick_travel/adapter'

module QuickTravel
  class PropertyType < Adapter
    attr_accessor :id, :name, :position

    self.api_base = '/property_types'
    self.lookup = true
  end
end
