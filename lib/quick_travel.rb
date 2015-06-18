# QuickTravel
#
module QuickTravel
  VERSION = '0.0.2'

  require 'active_support' # for .try, etc.

  require 'quick_travel/cache'
  require 'quick_travel/config'
  require 'quick_travel/adapter'
  require 'quick_travel/adapter_exception'
  require 'quick_travel/connection_error'

  # Don't include this guy: pull the pieces into the classes that use it, or ref
  require 'quick_travel/constants'

  require 'quick_travel/product'
  require 'quick_travel/product_configuration'
  require 'quick_travel/search'

  # QuickTravel models
  require 'quick_travel/graphic'
  require 'quick_travel/accommodation'
  require 'quick_travel/adapter'
  require 'quick_travel/address'
  require 'quick_travel/bed_configuration'
  require 'quick_travel/booking'
  require 'quick_travel/checkout'
  require 'quick_travel/client'
  require 'quick_travel/client_type'
  require 'quick_travel/contact'
  require 'quick_travel/country'
  require 'quick_travel/document'
  require 'quick_travel/document_group'
  require 'quick_travel/location'
  require 'quick_travel/party'
  require 'quick_travel/passenger'
  require 'quick_travel/passenger_type'
  require 'quick_travel/payment'
  require 'quick_travel/background_check'
  require 'quick_travel/payment_type'
  require 'quick_travel/product_type'
  require 'quick_travel/property'
  require 'quick_travel/property_facility'
  require 'quick_travel/property_type'
  require 'quick_travel/route'
  require 'quick_travel/region'
  require 'quick_travel/reservation'
  require 'quick_travel/resource'
  require 'quick_travel/room_facility'
  require 'quick_travel/route_stop'
  require 'quick_travel/service'
  require 'quick_travel/trip'
  require 'quick_travel/vehicle'
  require 'quick_travel/vehicle_type'

  require 'quick_travel/product_passenger_search_criteria'
  require 'money'
  require 'extensions'
end
