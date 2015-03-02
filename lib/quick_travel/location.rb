require 'quick_travel/adapter'

module QuickTravel
  class Location < Adapter
    attr_accessor :id, :name, :region_ids

    self.api_base = '/locations'
    self.lookup = true

    def regions
      Region.all.select { |r| region_ids.include?(r.id) }
    end
  end
end
