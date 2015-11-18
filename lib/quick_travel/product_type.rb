module QuickTravel
  class ProductType < Adapter
    attr_accessor :book_before_level, :book_before_units, :bookable_online, :can_find_by_location, :confirmation_request_fields, :default_passenger_ticket_format_id, :default_reservation_ticket_format_id
    attr_accessor :default_vehicle_ticket_format_id, :detailed_template_fields, :disclaimer_id, :durational, :id, :individual_tickets
    attr_accessor :individual_tickets, :mark_up_cents, :mark_up_definition_id, :mark_up_percent, :mark_up_rack_from_cost, :mark_up_rounding_cents
    attr_accessor :mark_up_rounding_direction, :maximum_passengers_online, :measure_units_by_pax_count, :multi_leg, :name, :no_ticket
    attr_accessor :only_bookable_with_accommodation, :overview_template_fields, :prompt_for_pick_up_drop_off, :resource_class_name, :rule_set_id,
                  :can_have_dates,
                  :can_have_quantity,
                  :needs_passengers

    self.api_base = '/api/product_types'

    def self.all
      QuickTravel::Cache.cache 'all_product_types' do
        super
      end
    end

    def route
      Route.first(id)
    end

    def routes
      Route.all(id)
    end
  end
end
