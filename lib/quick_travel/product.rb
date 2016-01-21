require 'quick_travel/adapter'

module QuickTravel
  class Product < Adapter
    self.api_base = '/api/products'

    # Find product details for a given product
    #
    # Options are::tabnew
    #   passenger_types: {<passenger_type_id> => <num_pax>, ...},
    #   date_range: {start_date: <date>, end_date: <date>}
    def self.find(id, params = {})
      if params[:passenger_type_numbers].blank?
        fail ArgumentError, 'Product#find requires passenger_type_numbers'
      end
      if params[:date_range].blank?
        fail ArgumentError, 'Product#find requires date_range'
      end
      super
    end

    def self.bulk_availability(resource_ids, date_from, date_to, units)
      request_params = {
        resource_ids: resource_ids,
        date_from:    date_from,
        date_to:      date_to,
        units:        units
      }
      get_and_validate('/api/availability/bulk.json', request_params)
    end

    def self.unavailable_dates(resource_ids, date_from, date_to)
      request_params = {
        resource_ids: resource_ids,
        date_from:    date_from,
        date_to:      date_to
      }
      get_and_validate('/api/availability/unavailable_dates.json', request_params)
    end

    # Returns minified mega structure:
    #
    # products_by_resource_id_and_date
    # {
    #   <resource-id> => {<date> => <product-instance>, ...},
    #   ...
    # }
    def self.fetch_and_arrange_by_resource_id_and_date(resource_ids, options = {})
      request_params = options.clone
      request_params[:resource_ids] = resource_ids

      # Returned call mega-structure is:
      # [
      #   {
      #     "resource" => {"id" => <resource-id>, "name" => <resource-name>},
      #     "bookability" => {
      #       <date-as-string>  => {<product-attrs}
      #       ...
      #     }
      #   },
      #   ...
      # ]
      complex_data = get_and_validate('/api/products/date_range_bookability.json', request_params)
      complex_data ||= {}

      products_by_resource_id_and_date = {}

      # Go through shitty complex_grid_data
      complex_data.each do |resource_and_bookability_hash|
        resource_id = resource_and_bookability_hash.fetch('resource', {}).fetch('id', nil)
        product_attrs_by_date = resource_and_bookability_hash.fetch('bookability', {})

        products_by_resource_id_and_date[resource_id] = {}
        product_attrs_by_date.each do |date, product_attrs|
          products_by_resource_id_and_date[resource_id][date] = new(product_attrs)
        end
      end

      products_by_resource_id_and_date
    end

    # needed as captain cook grid cell exepcts them to be defined
    attr_reader :pricing_details_for_rack_rate,
                :pricing_details_without_rules

    def id
      @reservation_attributes['resource_id']
    end

    def name
      @selection_name
    end

    def available?
      !!@available
    end

    def extras=(extra_attrs)
      @extras = extra_attrs.map do |extra_attr|
        QuickTravel::Product.new(extra_attr)
      end
    end

    def select_extras_by_id(selected_ids)
      @extras.select { |extra| selected_ids.include? extra.id }
    end

    def resource=(resource_hash)
      @resource = QuickTravel::Resource.new(resource_hash)
    end

    def availability_details=(availability_details)
      @availability_details = AvailabilityDetails.new(availability_details)
    end

    def pricing_details=(pricing_details)
      @pricing_details = PricingDetails.new(pricing_details)
    end

    def pricing_details_for_rack_rate=(pricing_details_for_rack_rate)
      @pricing_details_for_rack_rate = PricingDetails.new(pricing_details_for_rack_rate)
    end

    def pricing_details_without_rules=(pricing_details_without_rules)
      @pricing_details_without_rules = PricingDetails.new(pricing_details_without_rules)
    end
  end

  class PricingDetails < Adapter
    money :minimum_price, :minimum_price_with_adjustments, :total_adjustments

    def price_per_pax_type=(pax_type_hash)
      @price_per_pax_type = convert_pax_type_hash(pax_type_hash)
    end

    def convert_pax_type_hash(pax_type_hash)
      pax_type_hash.each.with_object({}) { |(type, cents), hash| hash[type.to_i] = Money.new(cents.to_i) }
    end
  end

  class AvailabilityDetails < Adapter
  end

  class PricePerPaxType < Adapter
    attr_accessor :amount_in_cents
  end
end
