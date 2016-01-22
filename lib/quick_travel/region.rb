require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class Region < Adapter
    include Cache

    self.api_base = '/regions'
    self.lookup = true

    def locations
      Location.all.select { |l| location_ids.include?(l.id) }
    end
  end
end
