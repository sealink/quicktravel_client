require 'quick_travel/adapter'
require 'quick_travel/passenger'
require 'quick_travel/vehicle'
require 'quick_travel/payment'
require 'quick_travel/payment_type'
require 'quick_travel/price_changes'
require 'uri'

module QuickTravel
  class Booking < Adapter
    def self.api_base
      '/api/bookings'
    end

    def self.find_by_reference(reference)
      find_all!("#{api_base}/reference/#{URI.escape(reference)}.json").first
    end

    def documents(regenerate = false)
      Document.find_all!("#{Booking.api_base}/#{@id}/documents.json",
                         last_group: true, regenerate: regenerate)
    end

    has_many :reservations
    has_many :passengers
    has_many :vehicles
    has_many :payments
    has_many :payment_types

    def on_account_payment_type
      payment_types_by_code = payment_types.group_by(&:code)

      # Try on-account, or if not, on-account-with-reference
      payment_types_by_code['on_account_without_reference'].try(:first) ||
        payment_types_by_code['on_account_with_reference'].try(:first)
    end

    def country
      Country.find(@country_id) if @country_id
    end

    # Create an empty booking
    #
    # Note, options pertain to initializing booking with some values:
    #
    # options = {
    #  :when => "28-04-2010" ,
    #  :passengers => { "1" => nil, "2" => nil, "3" => nil, "4" => nil , "5" => nil } ,
    #  :include_vehicle => nil , :vehicle => { :vehicle_type_id => nil , :length , :weight  } ,
    #  :vehicle_return_weight  => nil ,
    #  :include_trailer  => nil ,
    #  :trailer => { :vehicle_type_id => nil , :length => nil  }
    # }
    def self.create(options = {})
      response = post_and_validate("#{api_base}.json", booking: options)
      fail AdapterError.new(response) unless response['id']

      return nil unless response['id']
      Booking.new(response)
    end

    # Update an existing booking
    def update(attrs = {}, options = {})
      response_object = put_and_validate("#{api_base}/#{@id}.json", options.merge(booking: attrs), return_response_object: true)
      response = response_object.parsed_response
      # id is returned if other attributes change otherwise success: true
      fail AdapterError.new(response) unless response_object.no_content? || response['id'] || response['success']

      Booking.find(@id)
    end

    # ###
    # Updates:
    #   - Client information
    #   - Client contact
    #   - Client address
    #   - Pax details
    #   - Vehicle details
    def update_with_nested_attributes!(booking_args = {})
      response = put_and_validate("#{api_base}/#{@id}/update_with_nested_attributes.json",
                                  booking: booking_args)
      fail AdapterError.new(response) unless response['id']
      Booking.find(response['id'])
    end

    def remove_unassigned_passengers
      put_and_validate("/api/bookings/#{@id}/remove_unassigned_passengers")
    end

    # Create an accommodation reservation from the given options
    #
    # Returns current booking object after having added the reservation
    #
    # reservations_options = {
    #   :id => nil ,
    #   :first_travel_date => nil,
    #   :last_travel_date => nil,
    #   :resource_id => nil ,
    #   :passenger_ids => {} ,
    #   :vehicle_ids => {} ,
    #   :bed_configuration_id => nil ,
    #   :tariff_level_id => nil
    # }
    #
    # Example 2:
    # reservations_options = {
    #   :first_trave_date => "28-04-2010",
    #   :last_travel_date => "28-04-2010",
    #   :resource_id => 89,
    #   :bed_configuration_id => 581,
    #   :passenger_ids => {""=>nil},
    #   :vehicle_ids => {""=>nil}
    # }
    def accommodation_reserve(reservations_options = {})
      if reservations_options[:last_travel_date].nil?
        fail AdapterError.new('No checkout date specified')
      end

      reserve('accommodations/create_or_update', reservations: reservations_options)
    end

    # Reserve a scheduled trips resource
    # Returns current booking object after having added the reservation
    #
    # Note:
    # Forward_options and return_options look similar, but each is a different trip
    #
    # Example:
    # forward_options = {
    #   :passenger_ids => {} ,
    #   :vehicle_ids => {} ,
    #   :first_travel_date => nil,
    #   :tariff_level_id => nil ,
    #   :resource_id => nil ,
    #   :trip_id => nil
    # }
    def scheduled_trips_reserve(segments = {})
      reserve(:scheduled_trips, segments.merge(segments: segments.keys))
    end

    def scheduled_trips_update(segments = {})
      params = segments.merge(segments: segments.keys)
      params[:booking_id] = @id
      put_and_validate('/reservation_for/scheduled_trips/bulk_update.json', params)
      Booking.find(@id)
    end

    def generics_reserve(options)
      reserve(:generics, options)
    end

    def item_reserve(options)
      reserve(:items, options)
    end

    def tour_reserve(options)
      reserve(:packages, options)
    end

    # Delete a reservation
    #
    # Returns current booking object after deleting the reservation
    def delete_reservation(reservation)
      delete_reservation_by_id(reservation.id)
    end

    def delete_reservation_by_id(reservation_id)
      if state != 'new'
        fail AdapterError.new('Reservation cannot be deleted unless the booking is new')
      end

      delete_and_validate("#{api_base}/#{@id}/reservations/#{reservation_id}.json")
      refresh!
    end

    def refresh!
      Booking.find(@id)  # refresh
    end

    def find_passenger_by_id(pid)
      passengers.detect { |p| p.id.to_i == pid.to_i }
    end

    def find_vehicle_by_id(vid)
      vehicles.detect { |v| v.id.to_i == vid.to_i }
    end

    def passenger_types_counts
      passengers.each_with_object(Hash.new(0)) do |passenger, hash|
        hash[passenger.passenger_type_id] += 1
      end
    end

    def client_address
      return nil unless @client_address
      @client_address_object ||= Address.new(@client_address)
    end

    def client_party
      return nil unless @client_party
      @client_party_object ||= Party.new(@client_party)
    end

    def client_contact
      return nil unless @client_contact
      @client_contact_object ||= Contact.new(@client_contact)
    end

    def client
      return nil unless @client
      @client_object ||= Client.new(@client)
    end

    def calculate_existing_and_new_vehicles_for(required_vehicle_types)
      return [[], []] if required_vehicle_types.blank?

      vehicle_types_to_add = []
      existing_vehicle_ids_to_assign = []

      vehicles_yet_to_include = try(:vehicles)

      required_vehicle_types.each do |searched_vehicle_type_hash|
        matching_existing_vehicle = vehicles_yet_to_include.detect { |veh| veh.vehicle_type_id.to_i == searched_vehicle_type_hash[:vehicle_type_id].to_i }
        if matching_existing_vehicle
          existing_vehicle_ids_to_assign << matching_existing_vehicle.id.to_i
          vehicles_yet_to_include -= [matching_existing_vehicle]

        else
          vehicle_types_to_add << searched_vehicle_type_hash
        end
      end

      [existing_vehicle_ids_to_assign, vehicle_types_to_add]
    end

    def include_reservation_of?(product_type_id)
      reservations.any? { |r| r.product_type_id.to_i == product_type_id }
    end

    def includes_resource_class?(resource_class_name)
      reservations.any? { |r| r.resource_class_name == resource_class_name }
    end

    def clear_unfinished_reservations!
      booking = self
      reservations.reject(&:complete).each do |reservation|
        # This will return updated booking..
        booking = delete_reservation(reservation)
      end
      booking
    end

    def finalised?
      (balance_in_cents == 0 && state != 'new' && !reservations.empty?) || state == 'quote'
    end

    def price_change
      @price_change ||= fetch_price_change
    end

    def price_change_on(reservation)
      price_change.price_change_on(reservation.id)
    end

    def total_price_change_on(reservation)
      price_change.total_price_change_on(reservation.id)
    end

    # <b>DEPRECATED:</b>
    # Please use <tt>PriceQuote.calculate(params.merge(booking_id: booking.id))</tt> instead.
    def calculate_price_quote(params = {})
      response = post_and_validate("#{api_base}/#{@id}/price_quotes/calculate", params)
      Money.new(response['quoted_booking_gross_in_cents'])
    end

    def activate!
      put_and_validate("#{api_base}/#{@id}/activate")
    end

    def cancel!
      put_and_validate("#{api_base}/#{@id}/cancel")
    end

    def subscribe_to_email_list(email = nil)
      params = email.nil? ? {} : { email: email }
      put_and_validate("#{api_base}/#{@id}/subscribe_to_email_list", params)
    end

    # secureAccessCodeString is simply a MAC algorithm (using SHA1) on the booking id string.
    # it is using @id that is booking.id and configuration constant QUICK_TRAVEL_ACCESS_KEY
    def secure_access_code
      Encrypt.access_key(@id.to_s)
    end

    protected

    def reserve(url, options)
      options[:booking_id] = @id
      post_and_validate("/reservation_for/#{url}.json", options)
      Booking.find(@id)
    end

    private

    def fetch_price_change
      attributes = get_and_validate("#{api_base}/#{@id}/price_change.json")
      QuickTravel::PriceChanges::BookingPriceChange.new(attributes)
    end
  end
end
