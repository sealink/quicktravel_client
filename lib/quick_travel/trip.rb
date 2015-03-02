require 'quick_travel/adapter'

module QuickTravel
  class Trip < Adapter
    self.api_base = '/api/trips'
    attr_accessor :route_id
  end
end
