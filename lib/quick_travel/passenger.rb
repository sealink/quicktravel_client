require 'quick_travel/init_from_hash'

module QuickTravel
  class Passenger
    include QuickTravel::InitFromHash

    def passenger_type
      QuickTravel::PassengerType.find(@passenger_type_id)
    end
  end
end
