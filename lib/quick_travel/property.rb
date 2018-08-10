require 'quick_travel/adapter'
require 'quick_travel/property_facility'

module QuickTravel
  class Property < Adapter
    self.api_base = '/api/properties'
    attr_reader :error

    def accommodations=(hash_array)
      @accommodations = hash_array.map { |accommodation_hash| Accommodation.new(accommodation_hash) }
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
      find_all!('/api/properties.json', condition)
    end

    def self.load_with_pricing(id, options)
      # Find property 'standard' way -- finds price for whole duration
      fail ArgumentError.new('Must Specify valid property id') if id.blank? || !id.is_a?(Integer)
      property = find_all!("/api/properties/#{id}.json", options).first
      first_travel_date = options.fetch(:product).fetch(:first_travel_date)
      property.accommodations.each do |accommodation|
        # Is this right? Why is first_travel_date assumed to be cheapest
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

    def location
      @_location ||= Location.find(location_id)
    end

    def property_types
      @_property_types ||= PropertyType.all.select{ |pt| property_type_ids.include?(pt.id) }
    end
  end
end
