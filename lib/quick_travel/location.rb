require 'quick_travel/adapter'

module QuickTravel
  class Location < Adapter
    self.api_base = '/locations'
    self.lookup = true

    def regions
      Region.all.select { |r| region_ids.include?(r.id) }
    end
  end
end
