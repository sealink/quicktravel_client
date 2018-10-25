require 'quick_travel/init_from_hash'

module QuickTravel
  class RouteStop
    include QuickTravel::InitFromHash

    def stop
      Stop.new({
        id: stop_id,
        name: name,
        code: code,
        address: address,
        longitude: longitude,
        latitude: latitude
      })
    end
  end

  class Stop
    include QuickTravel::InitFromHash
  end
end
