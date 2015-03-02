require 'quick_travel/adapter'

module QuickTravel
  class RouteStop < Adapter
    attr_accessor :id, :name, :address, :code, :position, :route_id
  end
end
