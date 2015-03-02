require 'quick_travel/adapter'
require 'geokit'

module QuickTravel
  class Address < Adapter
    attr_accessor :address_line1, :address_line2, :city, :country_id, :id, :post_code, :state, :country_name

    def initialize(hash)
      super(hash)
      if @country_id == AUSTRALIA_COUNTRY_ID
        @country_name = 'Australia'
      end
    end

    def geocode
      @_geocode ||= QuickTravel::Cache.cache("geocode_#{self}") {
        Geokit::Geocoders::MultiGeocoder.geocode(to_s)
      }
    rescue Geokit::Geocoders::TooManyQueriesError
      nil # do not cache, do not error
    end

    def to_s
      "#{address_line1} #{address_line2}, #{city}, #{post_code}, #{state}, #{country_name}"
    end
  end
end
