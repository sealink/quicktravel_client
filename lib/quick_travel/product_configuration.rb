require 'quick_travel/adapter'
require 'set'

module QuickTravel
  class ProductConfiguration
    attr_reader :product, :extra_pick_configurations
    delegate :id, :name, to: :product

    def initialize(product)
      @product = product
      @selected = false
      @extra_pick_configurations =
        product.extras.map { |extra_pick| self.class.new(extra_pick) }
    end

    def select!
      @selected = true
    end

    def deselect!
      @selected = false
    end

    def selected?
      @selected
    end

    def available?
      @product.available? &&
        selected_extra_pick_configurations.all?(&:available?)
    end

    def priced?
      @product.pricing_details.present?
    end

    def price
      pricing_details.minimum_price_with_adjustments
    end

    def price_without_rules
      pricing_details_without_rules.minimum_price_with_adjustments
    end

    def price_for_rack_rate
      pricing_details_for_rack_rate.minimum_price_with_adjustments
    end

    def total_price
      price + selected_extra_picks_price
    end

    def total_price_without_rules
      price_without_rules + selected_extra_picks_price_without_rules
    end

    def total_price_for_rack_rate
      price_for_rack_rate + selected_extra_picks_price_for_rack_rate
    end

    def applied_rules
      pricing_details.applied_rules.uniq
    end

    def total_applied_rules
      (applied_rules + selected_extra_picks_applied_rules).uniq
    end

    def price_per_passenger_type(passenger_type_id)
      pricing_details.price_per_pax_type[passenger_type_id]
    end

    def selected_extra_pick_configurations
      @extra_pick_configurations.select(&:selected?)
    end

    def available_extra_pick_configurations
      @extra_pick_configurations.select(&:available?)
    end

    def select_extra_picks(extra_picks)
      extra_picks.each do |extra_pick|
        select_extra_pick(extra_pick)
      end
    end

    def select_extra_pick(extra_pick)
      extra_pick_configuration = configuration_for(extra_pick)

      if extra_pick_configuration.nil?
        fail ArgumentError, 'That extra pick does not belong to the product'
      end

      extra_pick_configuration.select!
    end

    private

    def configuration_for(extra_pick)
      @extra_pick_configurations.find do |extra_pick_configuration|
        extra_pick_configuration.product == extra_pick
      end
    end

    def selected_extra_picks_price
      selected_extra_pick_configurations.map(&:price).total_money
    end

    def selected_extra_picks_price_without_rules
      selected_extra_pick_configurations.map(&:price_without_rules).total_money
    end

    def selected_extra_picks_price_for_rack_rate
      selected_extra_pick_configurations.map(&:price_for_rack_rate).total_money
    end

    def selected_extra_picks_applied_rules
      selected_extra_pick_configurations.flat_map(&:applied_rules)
    end

    def pricing_details
      fail 'Unable to calculate pricing details' unless priced?
      @product.pricing_details
    end

    def pricing_details_without_rules
      @product.pricing_details_without_rules || pricing_details
    end

    def pricing_details_for_rack_rate
      @product.pricing_details_for_rack_rate || pricing_details
    end
  end
end
