require 'quick_travel/adapter'
require 'quick_travel/bed_configuration'
require 'quick_travel/room_facility'

module QuickTravel
  class Accommodation < Adapter
    # TODO: find a dynamic way to provide getter/setters for all data members instead of writing all of them.

    attr_accessor :book_before_level, :book_before_units, :bookable_individually, :bookable_online, :booking_notes, :code, :created_at
    attr_accessor :days_before_inventory_expires, :default_capacity, :deposit_id, :disclaimer_id, :expiry_level, :expiry_units, :fare_basis_pointer_id
    attr_accessor :frequent_traveller_points_multiplier, :guardian_minimum_age, :id, :inline_cost_in_cents, :inline_price_in_cents, :inline_pricing
    attr_accessor :inventory_type, :active, :location_id, :masterpoint_resource_id, :maximum_occupancy, :maximum_passengers, :maximum_passengers_online
    attr_accessor :maximum_weight, :minimum_age, :minimum_passengers, :name, :no_expiry, :non_commissionable, :on_request_after_inventory_expiration
    attr_accessor :overriding_passenger_ticket_format_id, :overriding_reservation_ticket_format_id, :overriding_vehicle_ticket_format_id
    attr_accessor :product_type_id, :property_id, :property_type_id, :reason_required, :report_changes, :required_number_of_vehicles
    attr_accessor :resource_category_id, :restrict_to_client_types, :star_rating, :type, :unlimited_uses, :updated_at, :uses, :vendor_id
    attr_accessor :availability, :minimum_bookable_duration, :description,
                  :minimum_price, :nightly_price
    attr_accessor :on_request
    attr_accessor :error

    attr_reader :bed_configurations, :room_facilities

    MAX_DAYS = 8

    def bed_configurations=(hash_array)
      @bed_configurations = hash_array.map { |bed_configuration_hash| BedConfiguration.new(bed_configuration_hash) }
    end

    def room_facilities=(hash_array)
      @room_facilities = hash_array.map { |room_facility_hash| RoomFacility.new(room_facility_hash) }
    end

    # The minimum price may be in 'nightly' or 'whole-duration-totalled' form, depending on options given to API
    #
    # I use these accessors to set it up as is more sane for users of the class.
    attr_accessor :minimum_nightly_price, :minimum_price_for_duration

    def minimum_price_on(date)
      return nil if minimum_price.blank? || minimum_price[date.to_s].blank?
      Money.new(minimum_price[date.to_s])
    end

    def nightly_price_on(date)
      return nil if nightly_price.blank? || nightly_price[date.to_s].blank?
      Money.new(nightly_price[date.to_s])
    end

    def available_over_dates?(dates)
      return false if dates.empty?
      dates.all? { |date| available_on?(date.to_s) }
    end

    def available_on?(date)
      availability[date.to_s]
    end

    # Returns resource -- use for full information
    def full_information
      return @full_resource if @full_resource.present?
      @full_resource = Resource.first(@id) unless @id.blank?
    end

    def graphics=(graphics)
      @graphic_attributes = graphics
    end

    def graphics
      @graphics ||= @graphic_attributes.map { |g| QuickTravel::Graphic.new(g) }
    end
  end
end
