require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class Region < Adapter
    include Cache

    attr_accessor :id, :name, :location_ids

    self.api_base = '/regions'
    self.lookup = true

    def self.first
      generic_first '/regions.json'
    end

    def locations
      Location.all.select { |l| location_ids.include?(l.id) }
    end
  end
end
