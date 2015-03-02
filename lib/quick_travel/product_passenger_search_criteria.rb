module QuickTravel
  class ProductPassengerSearchCriteria
    def self.from_passengers(passengers)
      new.tap do |product_passenger_search_criteria|
        passengers.each do |passenger|
          product_passenger_search_criteria.add_passenger_of_type(passenger.passenger_type_id)
        end
      end
    end

    def initialize
      @passenger_count_by_type = {}
    end

    def add_passenger_of_type(passenger_type_id)
      @passenger_count_by_type[passenger_type_id] ||= 0
      @passenger_count_by_type[passenger_type_id] += 1
    end

    def set_count_for_passenger_type(passenger_type_id, count)
      @passenger_count_by_type[passenger_type_id] = count
    end

    def to_hash
      @passenger_count_by_type
    end
  end
end
