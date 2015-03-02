require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class Country < Adapter
    attr_accessor :id, :iso_3166_code, :name, :latitude, :longitude

    self.api_base = '/api/countries'
    self.lookup = true
  end
end
