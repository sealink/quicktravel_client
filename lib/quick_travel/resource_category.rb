require 'quick_travel/adapter'

module QuickTravel
  class ResourceCategory < Adapter
    self.api_base = '/api/resource_categories'
    self.lookup = true
  end
end
