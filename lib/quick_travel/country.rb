require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class Country < Adapter
    self.api_base = '/api/countries'
    self.lookup = true
  end
end
