require 'quick_travel/adapter'
require 'quick_travel/bed_configuration'
require 'quick_travel/room_facility'

module QuickTravel
  class Accommodation < Adapter
    attr_reader :error
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
