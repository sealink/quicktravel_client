require 'quick_travel/adapter'

module QuickTravel
  class Trip < Adapter
    self.api_base = '/api/trips'
  end
end
