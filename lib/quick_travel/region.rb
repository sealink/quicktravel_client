require 'quick_travel/adapter'

module QuickTravel
  class Region < Adapter
    self.api_base = '/regions'
    self.lookup = true

    def locations
      Location.all.select { |l| location_ids.include?(l.id) }
    end
  end
end
