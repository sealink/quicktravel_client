require 'quick_travel/adapter'

module QuickTravel
  class DropOffLocation < Adapter
    def self.api_base
      '/api/drop_off_locations'
    end
  end
end
