require 'quick_travel/adapter'

module QuickTravel
  class Country < Adapter
    self.api_base = '/api/countries'
    self.lookup = true
  end
end
