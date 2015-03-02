module QuickTravel
  class Service < Adapter
    attr_accessor :id, :capacity, :booked, :weight, :max_weight, :unit_name, :deck_services
  end
end
