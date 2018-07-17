require 'quick_travel/init_from_hash'

module QuickTravel
  class RouteStop
    include QuickTravel::InitFromHash

    def stop
      Stop.new(stop_id, name, code, address)
    end
  end

  class Stop
    attr_accessor :id, :name, :code, :address

    def initialize(id, name, code, address)
      @id = id
      @name = name
      @code = code
      @address = address
    end
  end
end
