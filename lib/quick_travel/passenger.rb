require 'quick_travel/adapter'

module QuickTravel
  class Passenger < Adapter
    attr_accessor :id, :passenger_type_id, :age, :gender, :title, :first_name, :last_name, :details, :passenger_type_name
  end
end
