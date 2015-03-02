require 'quick_travel/init_from_hash'

module QuickTravel
  class Search
    attr_accessor :property_type_id, :property_name, :product, :last_travel_date, :location_id
    attr_accessor :category # type of search
    attr_accessor :way # used for one_way or two_way in "getting there search"
    attr_accessor :route_id # for getting there search
    attr_accessor :number_of_rooms  # required for accommodation search
    attr_accessor :forward_connection_date, :backward_connection_date

    include QuickTravel::InitFromHash
  end
end
