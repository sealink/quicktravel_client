require 'quick_travel/adapter'
require 'quick_travel/bed_requirement'
require 'quick_travel/passenger_price_break'
require 'quick_travel/product_type'

module QuickTravel
  class Resource < Adapter
    self.api_base = '/api/resources'

    def sub_resources
      Resource.find_all!('/api/resources.json', parent_resource_id: @id)
    end

    def self.find(id, opts = {})
      opts = { cache_key: "resource:#{id}", cache_options: { expires_in: 1.hour } }.merge(opts)
      super(id, opts)
    end

    def self.all_with_price(opts)
      cache_key = GenerateCacheKey.new(name, opts).call
      find_all!("/api/resources/index_with_price.json", opts.merge(cache_key: cache_key))
    end

    def product_type
      QuickTravel::ProductType.find(product_type_id)
    end

    def category
      return nil if @category.nil?
      @_category ||= QuickTravel::ResourceCategory.new(@category)
    end

    def bed_requirements
      @_bed_requirements ||= Array.wrap(@bed_requirements).map do |bed_requirement|
        BedRequirement.new(bed_requirement)
      end
    end

    private

    class GenerateCacheKey
      def initialize(resource_name, opts)
        @resource_name = resource_name
        @opts = opts
      end

      def call
        "#{@resource_name}.all_with_price-attrs?#{cache_params.to_param}"
      end

      private

      def cache_params
        { date: Date.current }.merge(@opts.symbolize_keys)
      end
    end
  end
end
