require 'quick_travel/adapter'

module QuickTravel
  class DropOffOption < Adapter
    def self.api_base
      '/api/drop_off_options'
    end
  end
end
