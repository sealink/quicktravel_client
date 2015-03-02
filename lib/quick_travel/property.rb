require 'quick_travel/adapter'
require 'quick_travel/property_facility'

module QuickTravel
  class Property < Adapter
    attr_accessor :id, :name,  :check_in, :check_in_instructions, :check_out, :contact_id, :contact_person, :description
    attr_accessor :location_id, :notes, :star_rating, :tourism_accredited, :availability, :on_request
    attr_accessor :minimum_available_price_in_cents
    attr_accessor :graphic # required in property search object
    attr_accessor :boundary_start, :boundary_end, :season_id # added in API 3.8.*
    attr_accessor :minimum_bookable_duration
    attr_accessor :maximum_occupancy
    attr_accessor :location_name, :region_names, :error

    attr_reader :accommodations

    money :minimum_available_price

    def accommodations=(hash_array)
      @accommodations = hash_array.map { |accommodation_hash| Accommodation.new(accommodation_hash) }
    end

    # This method returns first object of Property based on property id from QuickTravel
    def self.first(id, options = {})
      fail ArgumentError.new('Must Specify valid property id') if id.blank? || id.class != Fixnum
      generic_first("/api/properties/#{id}.json", options)
    end

    # This method returns all objects of property from QuickTravel that match
    #
    # location_id is compulsory param
    # :property_type_id=>1, :location_id=>5
    #
    # Example response:
    #   { :property_type_id=>1, :location_id=>5  , :number_of_rooms => 1 ,  :product => {:first_travel_date => "07-05-2010" , :duration => 1 } }
    def self.find!(condition = {})
      condition[:number_of_rooms] = 1 if condition[:number_of_rooms].blank? ||  condition[:number_of_rooms].to_i < 1
      condition[:last_travel_date] = condition[:product][:last_travel_date].to_date - 1 if condition[:product].try(:fetch, :last_travel_date, nil)
      self.find_all!('/api/properties.json', condition)
    end

    def self.load_with_pricing(id, options)
      # Find property 'standard' way -- finds price for whole duration
      property = Property.first(id, options)
      first_travel_date = options[:product][:first_travel_date]
      property.accommodations.each do |accommodation|
        accommodation.minimum_nightly_price      = accommodation.nightly_price_on first_travel_date
        accommodation.minimum_price_for_duration = accommodation.minimum_price_on first_travel_date
      end

      property
    end

    def to_param
      "#{id}-#{name.gsub(' ', '-')}"
    end

    def self.all!
      self.find_all!('/properties.json')
    end

    # this method is only used for properties that are searched through find method, because QT_API returns graphic string in search results
    def graphic_url
      QuickTravel.url + graphic if graphic.present?
    end

    def graphics=(graphics)
      @graphic_attributes = graphics
    end

    def graphics
      @graphics ||= @graphic_attributes.map { |g| QuickTravel::Graphic.new(g) }
    end

    def accommodations_by_availability(stay_dates)
      accommodations.sort_by do |accommodation|
        (accommodation.available_over_dates?(stay_dates) ? 0 : 1)
      end
    end

    def check_availability(date)
      availability && availability[date.to_s]
    end

    def available?
      # self.availability.present? &&
      # self.availability.any?{|availability_level| availability_level == 'on_allotment_and_available' }
      availability.present? && availability.all? { |_date, is_avail| is_avail }
    end

    def property_facilities
      @_property_facilities ||= @property_facilities.map { |item| PropertyFacility.new(item) }
    end

    def address
      @_address ||= Address.new(@address)
    end
  end
end
