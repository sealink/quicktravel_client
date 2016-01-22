require 'quick_travel/adapter'
require 'quick_travel/cache'

module QuickTravel
  class PropertyType < Adapter
    include Cache

    attr_accessor :id, :name, :position

    def self.all
      QuickTravel::Cache.cache 'all_property_types' do
        self.find_all!('/property_types.json')
      end
    end
  end
end
