require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class PropertyType < Adapter
    include Cache

    def self.first(_id = nil)
      generic_first('/property_types.json')
    end

    def self.all
      QuickTravel::Cache.cache 'all_property_types' do
        self.find_all!('/property_types.json')
      end
    end
  end
end
